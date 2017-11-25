//
//  DetailViewController.swift
//  ''
//
//  Created by Haim Levy on 18/11/2017.
//  Copyright © 2017 Haim Levy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // Vars
    var isEdit : Bool = false;
    
    // Outlets
    @IBOutlet weak var txtFieldTitle: UITextField!;
    @IBOutlet weak var txtViewNotes: UITextView!;
    @IBOutlet weak var dtPickerDueDate: UIDatePicker!;
    @IBOutlet weak var switchHasDueDate: UISwitch!;
    
    
    @IBAction func handleEdit(_ sender: UIBarButtonItem) {
        // self.txtFieldTitle.isEnabled = true;
        
        if (isEdit)
        {
            isEdit = false
            sender.title = "Edit"
            
            // Diable UI
            txtFieldTitle.isEnabled = false;
            txtViewNotes.isEditable = false;
            dtPickerDueDate.isEnabled = false;
            switchHasDueDate.isEnabled = false;
            
            // Save the edited todo 
            detailItem?.title = txtFieldTitle.text!;
            detailItem?.notes = txtViewNotes.text;
            detailItem?.hasDueDate = switchHasDueDate.isOn
            
            if (switchHasDueDate.isOn) {
                detailItem?.dueDate = dtPickerDueDate.date;
            }
            else {
                detailItem?.dueDate = nil;
            }

        }
        else
        {
            isEdit = true
            sender.title = "Save"
            
            // Enable UI to add ability to edit todo info
            txtFieldTitle.isEnabled = true;
            txtViewNotes.isEditable = true;
            dtPickerDueDate.isEnabled = true;
            switchHasDueDate.isEnabled = true;
            
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let tField = txtFieldTitle {
                tField.text = detail.title;
            }
            if let txtViewNotes = self.txtViewNotes {
                if let notes = detail.notes {
                    txtViewNotes.text = notes;
                }
            }
            if let switchHasDueDate = self.switchHasDueDate {
                if let hasDueDate = detail.hasDueDate {
                    switchHasDueDate.isOn = hasDueDate;
                }
            }

            if let dtPickerDueDate = self.dtPickerDueDate {
                if let dueDate = detail.dueDate {
                    dtPickerDueDate.date = dueDate;
            }

        }
        
        }
        
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var detailItem: TodoVM? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    
}

