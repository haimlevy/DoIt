//
//  MasterViewController.swift
//  DoIt
//
//  Created by Haim Levy on 17/11/2017.
//  Copyright © 2017 Haim Levy. All rights reserved.
//

import UIKit
import CoreData

class TodoCell : UITableViewCell {
    @IBOutlet weak var btnCheckbox: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
}

class MasterViewController: UITableViewController {
    
    var indexPath: IndexPath?;
    var activityIndicator = UIActivityIndicatorView();
    
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
    var todoList = [TodoVM]();


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
        
//        self.activityIndicator.center = self.view.center;
//        self.activityIndicator.hidesWhenStopped = true;
//        self.activityIndicator.activityIndicatorViewStyle = .gray;
//        self.view.addSubview(activityIndicator);
//        self.activityIndicator.startAnimating();
        
        loadTodos();
        
        // getTodos();
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
        
        if (indexPath != nil) {
            self.tableView.reloadRows(at: [indexPath!], with: .automatic) }
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
    
    func insertTodo(todo: TodoVM) {
        saveTodo(todo);
        todoList.insert(todo, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func saveTodo(_ todo: TodoVM?){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        //**Note:** Here we are providing the entityName **`Entity`** that we have added in the model
        let newTodo = NSEntityDescription.insertNewObject(forEntityName: "TodoEntity", into: context)
        //let myItem = NSManagedObject(coreDataTodo: coreDataTodo!, insertInto: context)
        
        newTodo.setValue(todo?.title, forKey: "title")
        newTodo.setValue(todo?.notes, forKey: "notes")
        newTodo.setValue(todo?.hasDueDate, forKey: "hasDueDate")
        newTodo.setValue(todo?.dueDate, forKey: "dueDate")
        newTodo.setValue(todo?.completed, forKey: "completed")
        newTodo.setValue(Date.init(), forKey: "createdDate")
        
        do {
            try context.save()
        }
        catch{
            print("There was an error in saving data")
        }
    }
    
     func loadTodos() {
        // Obtaining data from model
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
        
        do {
            
            let results = try context.fetch(fetchRequest) as! [TodoEntity]
            
            var newTodoVM: TodoVM;
            var todoList = [TodoVM]();
            
            for todoEntity in results {
                newTodoVM = TodoVM.init(
                    id: 1,
                    userId: 46065,
                    title: todoEntity.title!,
                    completed: todoEntity.completed,
                    notes: todoEntity.notes,
                    dueDate: todoEntity.dueDate,
                    hasDueDate: todoEntity.hasDueDate)
                
                todoList.append(newTodoVM);
            }
            
            self.todoList = todoList;
            self.tableView?.reloadData();
            
            // print("myValue: \(myValue)")
        } catch {
            print("Error")
        }
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                self.indexPath = indexPath;
                let todo = todoList[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = todo
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//                controller.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .edit, target: self, action: Selector(""))
//                controller.navigationItem.rightBarButtonItem?.isEnabled = true;
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TodoCell;

        let todo = todoList[indexPath.row];
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
            todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            // TODO: Delete from storage also
        // } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        // }
        }
        
    }
    
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
                let todosData = try JSONDecoder().decode([TodoVM].self, from: data)
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    // print(articlesData)
                    // sleep(10);
                    self.todoList = todosData;
                    self.tableView?.reloadData();
                    self.activityIndicator.stopAnimating();
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

