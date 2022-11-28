//
//  EPubReaderConfigurator.swift
//  EpubBookReader
//
//  Created by Amr Elghadban on 23/11/2022.
//

import Foundation
import UIKit

//import Combine
//import UIKit
//import MobileCoreServices
//import WebKit
//import UniformTypeIdentifiers
//import R2Shared
//import R2Streamer
//import R2Navigator
//import Kingfisher
import ReadiumOPDS

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
    func instalPublication(url: URL, sender: UIViewController?) {

        func importPublication(from url: URL, sender: UIViewController?) {
            //LibraryModuleAPI
            guard let viewController = AppDelegate.shared?.window?.rootViewController else { return }
            _ = app.library.importPublication(from: url, sender: viewController)
            //library.openBook(book, forPresentation: true, sender: self)
            
            let asset = FileAsset(url: url)
            guard let mediaType = asset.mediaType() else {
                promise(.failure(.openFailed(Publication.OpeningError.unsupportedFormat)))
                return
            }
            
            self.streamer.open(asset: asset, allowUserInteraction: allowUserInteraction, sender: sender) { result in
                switch result {
                case .success(let publication):
                    promise(.success((publication, mediaType)))
                case .failure(let error):
                    promise(.failure(.openFailed(error)))
                case .cancelled:
                    promise(.failure(.cancelled))
                }
            }
        }
        
        func tryAdd(from url: URL) {
            importPublication(from: url, sender: sender)
        }
        
        OPDSParser.parseURL(url: url) { data, _ in
            DispatchQueue.main.async {
                if let downloadLink = data?.publication?.downloadLinks.first, let downloadURL = URL(string: downloadLink.href) {
                    tryAdd(from: downloadURL)
                } else {
                    tryAdd(from: url)
                }
            }
        }
        
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
        return false
    }
    
    func getReaderViewController() -> UIViewController? {
        return nil
    }
    
//    func getReaderViewController(for bi: BookInformation) -> UIViewController? {
//
//    }
    
}
