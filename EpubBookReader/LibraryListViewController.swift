//
//  LibraryListViewController.swift
//  EpubBookReader
//
//  Created by Amr Elghadban on 24/10/2022.
//

//import FolioReaderKit
import R2Shared
import R2Streamer

class LibraryListViewController: UIViewController {

    var bookName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func folioReaderKitPressed(_ sender: Any) {
        //        let config = FolioReaderConfig()
        //        let folioReader = FolioReader()
        //        folioReader.presentReader(parentViewController: self, withEpubPath: bookPath!, andConfig: config)
    }
    
    @IBAction func readiumPressed(_ sender: Any) {
        guard let name = bookName else { return }
        guard let bookPath = Bundle.main.path(forResource: name, ofType: "epub") else {
            return
        }

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

