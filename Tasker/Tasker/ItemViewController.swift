//
//  ItemViewController.swift
//  Tasker
//
//  Created by kevin flores on 10/21/19.
//  Copyright © 2019 kevin flores. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: UIViewController {
    var itemArray = [Item]()
    let tableView = UITableView()
    let searchController = UISearchController(searchResultsController: nil)

    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    let dataFilePath = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setupTableView()
        view.backgroundColor = .red
    }
    func setupTableView() {
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "itemCell")
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setUpNavigationBar() {
        self.navigationItem.title = "To do"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add Task",
            style: .plain,
            target: self,
            action: #selector(selectorRight(sender:)))
        setUpSearchBar()
    }
    
    @objc func selectorRight(sender: UIButton!) {
        var textField = UITextField()
        
        let alert = UIAlertController.init(title: "Add a Todo Item", message: "the button was pressed", preferredStyle: .alert)
        
        let action = UIAlertAction.init(title: "Add Item", style: .default) { (action) in
            //what will happen once the user taps on the button in the nav bar
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.status = false
            newItem.parentCategory = self.selectedCategory
            
            
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Todo Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error Encoding the data to the plist \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error while loading items: \(error)")
        }

        tableView.reloadData()
    }
    
    
} // end of view controller

extension ItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        let item = itemArray[indexPath.row]

        cell.textLabel?.text = item.title
        cell.accessoryType = item.status ? .checkmark : . none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        itemArray[indexPath.row].status = !itemArray[indexPath.row].status
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)

    }
}

extension ItemViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func setUpSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    func updateSearchResults(for searchController: UISearchController) {
      // TODO
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

