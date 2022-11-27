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
        installSampleBooks() // if books are already installed, it will do nothing.
        EPubReaderConfigurator.shared.app
    }
    
    // install sample epubs from bundle.
    func installSampleBooks() {
        EPubReaderConfigurator.shared.installPublication(fileName: "Alice.epub")
        EPubReaderConfigurator.shared.installPublication(fileName: "Doctor.epub")
        EPubReaderConfigurator.shared.installPublication(fileName: "English_Book.epub")
        EPubReaderConfigurator.shared.installPublication(fileName: "Arabic_Book.epub")
    }
    
    @IBAction func openArabicBook(_ sender: Any) {
        let name = "Arabic_Book.epub"
        let fileName = name
        let ePubReader = EPubReaderConfigurator.shared
        ePubReader.config(fileName)
        ePubReader.loadBook()
        guard let viewController = ePubReader.getReaderViewController() else { return }
        open(viewController)
    }
    
    @IBAction func openEnglishBook(_ sender: Any) {
        let name = "English_Book.epub"
        let fileName = name
        let ePubReader = EPubReaderConfigurator.shared
        ePubReader.config(fileName)
        ePubReader.loadBook()
        guard let viewController = ePubReader.getReaderViewController() else { return }
        open(viewController)
    }
    
    @IBAction func downloadAndOpenEnglishBook(_ sender: Any) {
        let downloadURL = "http://bbebooksthailand.com/phpscripts/bbdownload.php?ebookdownload=FederalistPapers-EPUB2"
        let fileName = "FederalistPapers.epub"
        let ePubReader = EPubReaderConfigurator.shared
        ePubReader.config(fileName)
        if ePubReader.loadBook() {
            guard let viewController = ePubReader.getReaderViewController() else { return }
            open(viewController)
        } else {
            // need to download
            let downloadFolder = ""
            download(downloadURL, fileName: fileName, folderDirName: downloadFolder) { [weak self] response in
                if case .success(_) = response {
                    ePubReader.installPublication(fileName: fileName)
                    guard let viewController = ePubReader.getReaderViewController() else { return }
                    self?.open(viewController)
                }
            }
        }
    }

    func open(_ viewController: UIViewController) {
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: false, completion: nil)
        
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    private var streamer: Streamer?
    
    func readium(bookName: String?, _ sender: Any) {
        guard let name = bookName else { return }
        guard let bookPath = Bundle.main.path(forResource: name, ofType: "epub") else {
            return
        }
        
        let url = URL(fileURLWithPath: bookPath, isDirectory: false)
        let asset = FileAsset(url: url)
        guard let mediaType = asset.mediaType() else {
            return
        }
        streamer = Streamer()
        streamer?.open(asset: asset, allowUserInteraction: true, sender: sender) { result in
            switch result {
            case .success(let publication):
                //promise(.success((publication, mediaType)))
                self.handle(publication)
                print("success")
            case .failure(let error):
                //promise(.failure(.openFailed(error)))
                print("error")
            case .cancelled:
                //promise(.failure(.cancelled))
                print("cancelled")
            }
        }
    }
    
    func handle(_ publication: Publication) {
        guard let publicationServer = PublicationServer() else {
            /// FIXME: we should recover properly if the publication server can't start, maybe this should only forbid opening a publication?
            fatalError("Can't start publication server")
        }
        
        publicationServer.removeAll()
        do {
            try publicationServer.add(publication)
        } catch {
            print("cancelled")
        }
    }
}

