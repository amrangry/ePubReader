//
//  ViewController.swift
//  EpubBookReader
//
//  Created by Amr Elghadban on 17/09/2022.
//  Copyright © 2022 ADKA Tech. All rights reserved.
//  www.adkatech.com
//

import UIKit

import R2Shared
import R2Streamer

class ViewController: UIViewController {
    
    var library: LibraryService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        _ = EPubReaderConfigurator.shared.app
    }
    
    @IBAction func deleteAllBooks(_ sender: Any) {
        let ePubReader = EPubReaderConfigurator.shared
        ePubReader.deleteAllBooks()
    }
    
    /*EnglishBook*/
    @IBAction func downloadAndOpenEnglishBook(_ sender: Any) {
        let downloadURLString = "http://bbebooksthailand.com/phpscripts/bbdownload.php?ebookdownload=FederalistPapers-EPUB2"
        let fileName = "FederalistPapers.epub"
        let bookTitle = "The Federalist Papers"
//        let path = "The Federalist Papers.epub"
        downloadOrRead(fileName: fileName, bookTitle: bookTitle, downloadURLString: downloadURLString)
    }
    
    /*ArabicBook*/
    @IBAction func downloadAndOpenArabicBook(_ sender: Any) {
        let downloadURLString = "https://www.adkatech.com/projects/DynamicLink/بلاد-تركب-العنكبوتepub.epub"
        let fileName = "بلاد-تركب-العنكبوتepub.epub"
        let bookTitle = "بلاد تركب العنكبوت"
//        let path = "بلاد-تركب-العنكبوتepub.epub"
        downloadOrRead(fileName: fileName, bookTitle: bookTitle, downloadURLString: downloadURLString)
    }
    
    @IBAction func goToLibrary(_ sender: Any) {
        let ePubReader = EPubReaderConfigurator.shared
        ePubReader.goToLibrary()
    }
    
}

extension ViewController {
    
    func downloadOrRead(fileName: String, bookTitle: String, downloadURLString: String) {
        let ePubReader = EPubReaderConfigurator.shared
        guard let downloadURL = downloadURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let check = ePubReader.isExist(bookTitle, downloadURL: downloadURL)
        if check {
            ePubReader.presentAlertForDownloadedBook("Book Already downloaded into your library!", presenter: self)
        } else {
            // need to download
            let downloadFolder = ""
            download(downloadURL, fileName: fileName, folderDirName: downloadFolder) { [unowned self] response in
                switch response {
                case .success(let value):
                    guard let fileURL = value as? URL else { return }
                    ePubReader.installPublication(url: fileURL, sender: self) { response in
                        switch response {
                        case .success(let value):
                            let book = value
                            print(book)
                            ePubReader.presentAlertForDownloadedBook("Book downloaded successfully into your library!", presenter: self)
                        case .failure(let error):
                            print(error)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}
