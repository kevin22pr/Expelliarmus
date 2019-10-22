//
//  ViewController.swift
//  Tasker
//
//  Created by kevin flores on 10/21/19.
//  Copyright © 2019 kevin flores. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
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
        self.navigationItem.rightBarButtonItem = .init(
            barButtonSystemItem: UIBarButtonItem.SystemItem.done,
            target: nil,
            action: #selector(selectorX)
        )
    }
    
    @objc func selectorX() { }
    
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

extension ViewController: UITableViewDataSource {
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
}
