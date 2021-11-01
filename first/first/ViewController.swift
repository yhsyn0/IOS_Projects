//
//  ViewController.swift
//  first
//
//  Created by hsyn on 1.11.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textLabel1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickButton0(_ sender: UIButton)
    {
        textLabel1.text = "Hello World !"
    }
    

}

