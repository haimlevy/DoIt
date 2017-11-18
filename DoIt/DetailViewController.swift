//
//  DetailViewController.swift
//  ''
//
//  Created by Haim Levy on 18/11/2017.
//  Copyright © 2017 Haim Levy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var txtFieldTitle: UITextField!
    
    func configureView() {
//        // Update the user interface for the detail item.
                if let detail = detailItem {
                    if let txt1 = txtFieldTitle {
        
                    txt1.text = detail.title;
                    // txtViewNotes.text = detail.notes;
        
                        // label.text = detail.description
                }
        
//                    if let txt2 = txtViewNotes {
//
//                        txt2.text = detail.notes;
//                        // txtViewNotes.text = detail.notes;
//
//                        // label.text = detail.description
//                    }
                }}
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var detailItem: Todo? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    
}

