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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setUpNavigationBar()
        loadItems()
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
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveItems()
        }
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)

        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func selectorLeft(sender: UIButton!) {
        print("Button pressed")
        let settings = SettingsViewController()
        self.navigationController?.pushViewController(settings, animated: true)
    }
    
    func setupTableView() {
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension CategoryTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVC = ItemViewController()
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
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
