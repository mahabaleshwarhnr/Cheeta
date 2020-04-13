//
//  ViewController.swift
//  Cheeta
//
//  Created by Mahabaleshwar on 06/02/20.
//  Copyright © 2020 TW. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        MusicListViewModel().fetchMusicList(searchTerm: "hamsalekha")
    }
}

