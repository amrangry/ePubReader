//
//  ViewController.swift
//  EpubBookReader
//
//  Created by Amr Elghadban on 17/09/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func openArabicBook(_ sender: Any) {
       print("Arabic")
    }
    
    @IBAction func openEnglishBook(_ sender: Any) {
       print("English")
    }
}

