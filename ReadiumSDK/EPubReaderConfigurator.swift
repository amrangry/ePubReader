//
//  EPubReaderConfigurator.swift
//  EpubBookReader
//
//  Created by Amr Elghadban on 23/11/2022.
//

import Foundation
import UIKit

class EPubReaderConfigurator {
    
    static let shared = EPubReaderConfigurator()
    
    private init() {
        app = try! AppModule()
    }
    
    private (set) var app: AppModule!
    
    // MARK: - Controller
    private var fileName: String?
    func config(_ value: String?) {
        fileName = value
    }
    
    // MARK: - ePub Book installation
    
    /// Imports a new publication to the library, either from:
    /// - a local file URL
    /// - a remote URL which will be downloaded
    func instalPublication(url: URL) {
        //LibraryModuleAPI
        guard let viewController = AppDelegate.shared?.window?.rootViewController else {
            return
        }
        app.library.importPublication(from: url, sender: viewController)
        //library.openBook(book, forPresentation: true, sender: self)
    }
    
    func installPublication(fileName: String) {
        
    }
    
    func openBook(fileName: String) {
        //find book
        //let book = books[indexPath.item]
        //  app.library.openBook(book, forPresentation: true, sender: nil)
        //        app.library.openBook(book, forPresentation: true, sender: self)
        //                .receive(on: DispatchQueue.main)
        //                .sink { completion in
        //                    if case .failure(let error) = completion {
        //                        self.libraryDelegate?.presentError(error, from: self)
        //                    }
        //                    done()
        //                } receiveValue: { pub in
        //                    libraryDelegate.libraryDidSelectPublication(pub, book: book, completion: done)
        //                }
        //                .store(in: &subscriptions)
    }
    
    @discardableResult
    func loadBook() -> Bool {
        // install sample epubs from bundle.
        return true
    }
    
    func getReaderViewController() -> UIViewController? {
        return nil
    }
    
//    func getReaderViewController(for bi: BookInformation) -> UIViewController? {
//
//    }
    
}
