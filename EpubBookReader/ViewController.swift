//
//  ViewController.swift
//  EpubBookReader
//
//  Created by Amr Elghadban on 17/09/2022.
//

import UIKit
//import FolioReaderKit
import R2Shared
import R2Streamer

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func openArabicBook(_ sender: Any) {
       print("Arabic")
        let name = "Arabic_Book"
        open(book: name)
    }
    
    @IBAction func openEnglishBook(_ sender: Any) {
       print("English")
       let name = "English_Book"
       open(book: name)
    }
    
    func open(book name: String) {
        guard let bookPath = Bundle.main.path(forResource: name, ofType: "epub") else {
            return
        }
//        let config = FolioReaderConfig()
//        let folioReader = FolioReader()
//        folioReader.presentReader(parentViewController: self, withEpubPath: bookPath!, andConfig: config)
        
        guard let url = URL(string: bookPath) else {
            return
        }
        let streamer = Streamer()
        streamer.open(asset: FileAsset(url: url), allowUserInteraction: true) { result in
            switch result {
            case .success(let publication):
            print("here")
            case .failure(let error):
               // alert(error.localizedDescription)
                print("here: \(error.localizedDescription)")
            case .cancelled:
                break
            }
        }
        
    }
}

