//
//  ViewController.swift
//  Tasker
//
//  Created by kevin flores on 10/21/19.
//  Copyright © 2019 kevin flores. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UIViewController {
    
    var categoryArray = [Category]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    
    var characters = ["One", "Two", "Three", "Four"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setUpNavigationBar()
        view.backgroundColor = .white
    }
    
    func setUpNavigationBar(){
        self.navigationItem.title = "First View"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Settings",
            style: .plain,
            target: self,
            action: #selector(selectorLeft(sender:)))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add Task",
            style: .plain,
            target: self,
            action: #selector(selectorRight(sender:)))
    }
    
    @objc func selectorRight(sender: UIButton!) {
        print("Button pressed")
        var textField = UITextField()

        let alert = UIAlertController.init(title: "Add a Category", message: "the button was pressed", preferredStyle: .alert)

        let action = UIAlertAction.init(title: "Add Category", style: .default) { (action) in
            //what will happen once the user taps on the button in the nav bar


            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!


            self.categoryArray.append(newCategory)
            self.saveItems()
        }

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func selectorLeft(sender: UIButton!) {
        print("Button pressed")
    }
    
    func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension CategoryTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = characters[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(ItemViewController(), animated: true, completion: nil)
    }
    
    // MARK: - Tableview Datasource Method
    func loadItems() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error while loading items: \(error)")
        }
    }
    
    // MARK: - Tableview Data Manipulation Methods
    
    func saveItems() {

        do {
            try context.save()
        } catch {
            print("Error Encoding the data to the plist \(error)")
        }
        self.tableView.reloadData()
    }
}
