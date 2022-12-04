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

    @IBAction func downloadAndOpenEnglishBook(_ sender: Any) {
//        let downloadURL = "http://bbebooksthailand.com/phpscripts/bbdownload.php?ebookdownload=FederalistPapers-EPUB2"
//        let fileName = "FederalistPapers.epub"
//        let ePubReader = EPubReaderConfigurator.shared
//
//        if ePubReader.loadBook() {
//            guard let viewController = ePubReader.getReaderViewController() else { return }
//            open(viewController)
//        } else {
//            // need to download
//            let downloadFolder = ""
//            download(downloadURL, fileName: fileName, folderDirName: downloadFolder) { [weak self] response in
//                if case .success(let value) = response {
//                    guard let fileURL = value as? URL else { return }
//                    ePubReader.installPublication(url: fileURL, sender: self)
//                  //  ePubReader.installPublication(fileName: fileName)
//                    guard let viewController = ePubReader.getReaderViewController() else { return }
//                    self?.open(viewController)
//                }
//            }
//        }
    }
    
    @IBAction func goToLibrary(_ sender: Any) {
        let ePubReader = EPubReaderConfigurator.shared
        ePubReader.goToLibrary()
    }

}

