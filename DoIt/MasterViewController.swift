//
//  MasterViewController.swift
//  DoIt
//
//  Created by Haim Levy on 17/11/2017.
//  Copyright © 2017 Haim Levy. All rights reserved.
//

import UIKit

class TodoCell : UITableViewCell {
    @IBOutlet weak var btnCheckbox: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
}

class MasterViewController: UITableViewController {
    
    // Back from add Modal
    @IBAction func unwindToTodos(segue:UIStoryboardSegue) {
        if let origin = segue.source as? AddViewController {
            let newTodo = origin.newTodo;
            // Do something with the data
            insertTodo(todo: newTodo!);
        }
    }
    
    var detailViewController: DetailViewController? = nil
    // var objects = [Any]()
    var todos = [Todo]();


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//        navigationItem.rightBarButtonItem = addButton
//        if let split = splitViewController {
//            let controllers = split.viewControllers
//            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
//        }
        
        getTodos();
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
        //todos.insert(Todo(), at: 0)
        //let indexPath = IndexPath(row: 0, section: 0)
        //tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func insertTodo(todo: Todo) {
        todos.insert(todo, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let todo = todos[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = todo
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TodoCell;

        let todo = todos[indexPath.row];
        cell.lblTitle.text = todo.title;
        cell.btnCheckbox.isSelected = todo.completed;
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        // } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        // }
        }}
    
    private func getTodos() {
        let urlString = "https://jsonplaceholder.typicode.com/todos"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            //Implement JSON decoding and parsing
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let todosData = try JSONDecoder().decode([Todo].self, from: data)
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    //print(articlesData)
                    self.todos = todosData;
                    self.tableView?.reloadData();
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            
            }.resume()
    }

    @IBAction func btnChecboxClicked(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected;
    }
    
    

}

