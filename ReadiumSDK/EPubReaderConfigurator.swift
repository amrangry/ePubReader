//
//  EPubReaderConfigurator.swift
//  EpubBookReader
//
//  Created by Amr Elghadban on 23/11/2022.
//

//import Foundation
//import UIKit
//
//import Combine
////import UIKit
////import MobileCoreServices
////import WebKit
////import UniformTypeIdentifiers
////import R2Shared
////import R2Streamer
////import R2Navigator
////import Kingfisher
//import ReadiumOPDS

import Combine
import UIKit
import MobileCoreServices
import WebKit
import R2Shared
import R2Streamer
import R2Navigator
import Kingfisher
import ReadiumOPDS
import UniformTypeIdentifiers

extension EPubReaderConfigurator {
    
    func goToLibrary() {
//        let ePubReader = EPubReaderConfigurator.shared
//        let app = ePubReader.app
        let rootViewController = AppDelegate.shared?.window?.rootViewController
        previousViewController = rootViewController
        // Library
        guard let viewerViewController = app?.library.rootViewController else { return }
        setAppNavigationController(controller: viewerViewController)
    }

    func backToPrevious() {
        setAppNavigationController(controller: previousViewController)
    }
    
    private func setAppNavigationController( controller: UIViewController?) {
        guard let root = controller else { return }
        AppDelegate.shared?.window?.rootViewController = root
        AppDelegate.shared?.window?.makeKeyAndVisible()
        //        guard let navigationController = navigationController else { return }
        //        navigationController.pushViewController(viewerViewController, animated: true)
    }

}

extension EPubReaderConfigurator {
    
    func presentAlertForDownloadedBook(_ message: String, presenter: UIViewController?) {
        //NSLocalizedString("Book already downloaded before into your library", comment: "Message: Book already downloaded before into your library")
        let alert = UIAlertController(
            title: NSLocalizedString("Alert", comment: "Title of the information alert"),
            message: message,
            preferredStyle: .alert
        )
        let confirmButton = UIAlertAction(title: NSLocalizedString("Go to Library", comment: "Confirmation button to renew a publication"), style: .default, handler: { [weak self] _ in
            self?.goToLibrary()
        })
        let dismissButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel viewing the publication"), style: .cancel)
        
        alert.addAction(dismissButton)
        alert.addAction(confirmButton)
        // Present alert.
        presenter?.present(alert, animated: true)
    }
    
}

class EPubReaderConfigurator {

    static let shared = EPubReaderConfigurator()
    
    var previousViewController: UIViewController?
    
    var sender: UIViewController = AppDelegate.shared?.window?.rootViewController ?? UIViewController()
    
    private init() {
        app = try! AppModule()
        let library = app.library
        if let libraryModule = library as? LibraryModule {
            libraryService = libraryModule.library
            libraryModuleDelegate = libraryModule.delegate
        }
        
        libraryService.allBooks()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.libraryModuleDelegate?.presentError(error, from: self.sender)
                }
            } receiveValue: { newBooks in
                self.books = newBooks
                //self.collectionView.reloadData()
            }
            .store(in: &subscriptions)
    }
    
    private (set) var app: AppModule!
    var libraryService: LibraryService! = nil
    weak var libraryModuleDelegate: LibraryModuleDelegate?
    var subscriptions = Set<AnyCancellable>()
    var books: [Book]?

    // MARK: - ePub Book installation
    func deleteAllBooks() {
        books?.forEach({ book in
            self.libraryService.remove(book)
                .sink { completion in
                    if case .failure(let error) = completion {
                        //log(.warning, "can't remove \(book.title)")
                        Debugger().printOut(error.localizedDescription, context: .error)
                    }
                } receiveValue: {}
                .store(in: &self.subscriptions)
            
        })
        print("\(books?.count)")
    }
    
    func findBook(_ name: String) -> Book? {
        let found = books?.first(where: { book in
            let title = book.title
            if title == name {
                return true
            } else {
                return false
            }
        })
        return found
    }
    
    func isExist(_ name: String, downloadURL: String) -> Bool {
        //        let downloadURL = "http://bbebooksthailand.com/phpscripts/bbdownload.php?ebookdownload=FederalistPapers-EPUB2"
        //        let fileName = "FederalistPapers.epub"
        
        
        //Book(title: fileName, type: epub, path: nil)
       let found = findBook(name)
        var result = false
        if found != nil {
            result = true
        }
        return result
    }
    
    /// Imports a new publication to the library, either from:
    /// - a local file URL
    /// - a remote URL which will be downloaded
    func installPublication(url: URL, sender: UIViewController?, completion: @escaping ResultResponse<Any>){
        guard let viewController = AppDelegate.shared?.window?.rootViewController else {
           // completion(.failure())
            return
        }
        app.library.importPublication(from: url, sender: viewController)
            .assertNoFailure()
            .sink(receiveValue: { book in
                completion(.success(book))
            })
            .store(in: &subscriptions)
    }
    
    func displayBook(_ name: String, sender: UIViewController) {
        
        func done() {
//                self.loadingIndicator.removeFromSuperview()
//                collectionView.isUserInteractionEnabled = true
        }
        
        guard let book = findBook(name) else { return }
        print(book)
        libraryService.openBook(book, forPresentation: true, sender: sender)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.libraryModuleDelegate?.presentError(error, from: sender)
                }
            } receiveValue: { pub in
//                let detailsViewController = self.factory.make(publication: pub)
//                detailsViewController.modalPresentationStyle = .popover
//                self.navigationController?.pushViewController(detailsViewController, animated: true)
                self.libraryModuleDelegate?.libraryDidSelectPublication(pub, book: book, completion: done)
            }
            .store(in: &subscriptions)
    }
}
