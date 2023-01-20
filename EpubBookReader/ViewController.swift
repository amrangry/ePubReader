//
//  ViewController.swift
//  EpubBookReader
//
//  Created by Amr Elghadban on 17/09/2022.
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
    
    @IBAction func downloadAndOpenEnglishBook(_ sender: Any) {
        
        //        "id": "271961",
        //        "type": "attachments",
        //        "attributes": {
        //            "name": "بلاد تركب العنكبوتepub",
        //            "file_name": "بلاد-تركب-العنكبوتepub.epub",
        //            "mime_type": "application/epub+zip",
        //            "size": "1.44 MB"
        //        },
        //        "links": {
        //            "self": "https://cdn.aseeralkotb.com/storage/media/271961/بلاد-تركب-العنكبوتepub.epub"
        //        }
        
        //        let downloadURL = "http://bbebooksthailand.com/phpscripts/bbdownload.php?ebookdownload=FederalistPapers-EPUB2"
        //        let fileName = "FederalistPapers.epub"
        //        let bookTitle = "The Federalist Papers"
        //        let type = "application/epub+zip"
        //        let path = "The Federalist Papers.epub"
        
        
        let downloadURLString = "https://cdn.aseeralkotb.com/storage/media/271961/بلاد-تركب-العنكبوتepub.epub"
        guard let downloadURL = downloadURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        print(downloadURL)
        let fileName = "بلاد-تركب-العنكبوتepub.epub"
        let bookTitle = "بلاد تركب العنكبوت"
        let type = "application/epub+zip"
        let path = "بلاد-تركب-العنكبوتepub.epub"
        
//        - title : "بلاد تركب العنكبوت"
//        ▿ authors : Optional<String>
//          - some : "منى سلامة"
//        - type : "application/epub+zip"
//        - path : "بلاد تركب العنكبوت.epub"
//        ▿ coverPath : Optional<String>
//          - some : "D9132820-BE26-409E-834C-D6951AD266A2"
//        - locator : nil
//        - progression : 0.0
//        ▿ created : ٢٠٢٢-١٢-٠٤ ١٩:٣٧:٥٤ +0000
//          - timeIntervalSinceReferenceDate : 691875474.774513
        
        let ePubReader = EPubReaderConfigurator.shared
        let check = ePubReader.isExist(bookTitle, downloadURL: downloadURL)
        if check {
            print(check)
            //ePubReader.app.presentAlert("Already Exist", message: "Book", from: self)//presentAlert("Success", message: "Book Downloaded", from: self)
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
                            let books = ePubReader.books
                            let check = ePubReader.isExist(bookTitle, downloadURL: downloadURL)
                            //print(books)
                            //ePubReader.app.presentAlert("Success", message: "Book Downloaded", from: self)
                            ePubReader.presentAlertForDownloadedBook("Book downloaded successfully into your library!", presenter: self)
                        case .failure(let error):
                            print(error)
                        }
                    }
                case .failure(let error):
                    print(error)
                    
                }
                //                if case .success(let value) = response { }
            }
        }
    }
    
    @IBAction func goToLibrary(_ sender: Any) {
        let ePubReader = EPubReaderConfigurator.shared
        ePubReader.goToLibrary()
    }
    
}

