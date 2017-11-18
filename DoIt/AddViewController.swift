//
//  AddViewController.swift
//  DoIt
//
//  Created by Haim Levy on 18/11/2017.
//  Copyright © 2017 Haim Levy. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var txtFldTitle: UITextField!
    @IBOutlet weak var txtViewNotes: UITextView!
    @IBOutlet weak var switchHasDueDate: UISwitch!
    @IBOutlet weak var dtPickerDueDate: UIDatePicker!
    
    @IBAction func handleDueDateSwitch(_ sender: UISwitch) {
        dtPickerDueDate.isEnabled = switchHasDueDate.isOn;
    }
    
    var newTodo: Todo?;
    
    @IBAction func save(_ sender: Any) {
        performSegue(withIdentifier: "unwindSegueToTodos", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindSegueToTodos" {
            newTodo = createTodo();
        }
    }
    
    func createTodo() -> Todo? {
        var dueDate : Date? = nil;
        
        if (switchHasDueDate.isOn) {
            dueDate = dtPickerDueDate.date;
        }
        
        let todo = Todo(
            id: 1,
            userId: 46065,
            title: txtFldTitle.text!,
            completed: false,
            notes: txtViewNotes.text,
            dueDate: dueDate,
            hasDueDate: switchHasDueDate.isOn
                
        )
        
        return todo;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.dtPickerDueDate.isEnabled = false;
        
        let color = UIColor(red: 186/255, green: 186/255, blue: 186/255, alpha: 1.0).cgColor
        self.txtViewNotes.layer.borderColor = color
        self.txtViewNotes.layer.borderWidth = 0.5
        self.txtViewNotes.layer.cornerRadius = 5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleCancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
