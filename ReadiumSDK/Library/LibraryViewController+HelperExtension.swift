//
//  LibraryViewController+HelperExtension.swift
//  EpubBookReader
//
//  Created by Amr Elghadban on 04/12/2022.
//

import Foundation
import UIKit
import R2Shared
import ReadiumOPDS
import UniformTypeIdentifiers


//import Combine
import MobileCoreServices

//import WebKit
//import R2Streamer
//import R2Navigator
//import Kingfisher
//import ReadiumOPDS


extension LibraryViewController {
    
    @objc func goBackButtonPressed() {
        let ePubReader = EPubReaderConfigurator.shared
        ePubReader.backToPrevious()
    }
    
    @objc func addBookButtonPressed() {
        let alert = UIAlertController(title: NSLocalizedString("library_add_book_title", comment: "Title for the Add book alert"), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("library_add_book_from_device_button", comment: "`Add a book from your device` button"), style: .default, handler: { _ in self.addBookFromDevice() }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("library_add_book_from_url_button", comment: "`Add a book from a URL` button"), style: .default, handler: { _ in self.addBookFromURL() }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel_button", comment: "Cancel adding a book from a URL"), style: .cancel))
        alert.popoverPresentationController?.barButtonItem = addBookButton
        present(alert, animated: true)
    }
    
    private func addBookFromDevice() {
        var types = DocumentTypes.main.supportedUTTypes
        if let type = UTType(String(kUTTypeText)) {
            types.append(type)
        }
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: types)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    private func addBookFromURL(url: String? = nil, message: String? = nil) {
        let alert = UIAlertController(
            title: NSLocalizedString("library_add_book_from_url_title", comment: "Title for the `Add book from URL` alert"),
            message: message,
            preferredStyle: .alert
        )
        
        func retry(message: String? = nil) {
            addBookFromURL(url: alert.textFields?[0].text, message: message)
        }
        
        func add(_ action: UIAlertAction) {
            let optionalURLString = alert.textFields?[0].text
            guard let urlString = optionalURLString,
                let url = URL(string: urlString) else
            {
                retry(message: NSLocalizedString("library_add_book_from_url_failure_message", comment: "Error message when trying to add a book from a URL"))
                return
            }
            
            func tryAdd(from url: URL) {
                library.importPublication(from: url, sender: self)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        if case .failure(let error) = completion {
                            retry(message: error.localizedDescription)
                        }
                    } receiveValue: { _ in }
                    .store(in: &subscriptions)
            }

            let hideActivity = toastActivity(on: view)
            OPDSParser.parseURL(url: url) { data, _ in
                DispatchQueue.main.async {
                    hideActivity()

                    if let downloadLink = data?.publication?.downloadLinks.first, let downloadURL = URL(string: downloadLink.href) {
                        tryAdd(from: downloadURL)
                    } else {
                        tryAdd(from: url)
                    }
                }
            }
        }
        
        alert.addTextField { textField in
            textField.placeholder = NSLocalizedString("library_add_book_from_url_placeholder", comment: "Placeholder for the URL field in the `Add book from URL` alert")
            textField.text = url
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("add_button", comment: "Add a book from a URL button"), style: .default, handler: add))
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel_button", comment: "Cancel adding a boom from a URL button"), style: .cancel))
        present(alert, animated: true, completion: nil)
    }
}
