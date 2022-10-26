//
//  LibraryListViewController.swift
//  EpubBookReader
//
//  Created by Amr Elghadban on 24/10/2022.
//

import R2Shared
import R2Streamer

class LibraryListViewController: UIViewController {
    
    @IBOutlet weak var bookTitle: UILabel?
    
    var bookName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = bookName
        bookTitle?.isHidden = true
    }
    
    private var streamer: Streamer?
    
    @IBAction func readiumPressed(_ sender: Any) {
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

