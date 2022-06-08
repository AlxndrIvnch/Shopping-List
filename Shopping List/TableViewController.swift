//
//  ViewController.swift
//  Milestone4-6
//
//  Created by Aleksandr on 03.06.2022.
//

import UIKit

class TableViewController: UITableViewController {
    var itemsList: [String]! {
        didSet {
            navigationItem.leftBarButtonItem?.isEnabled = !itemsList.isEmpty
            share.isEnabled = !itemsList.isEmpty
        }
    }
    var share: UIBarButtonItem!
    var spacer: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shopping list"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearList))
        
        share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        toolbarItems = [spacer, share]
        
        clearsSelectionOnViewWillAppear = true
        navigationItem.leftBarButtonItem?.isEnabled = false
        share.isEnabled = false
        navigationController?.isToolbarHidden = false
        
        itemsList = [String]()
    }

    @objc func addItem() {
        let ac = UIAlertController(title: "Enter item name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { [weak self, weak ac] _ in
            guard let index = self?.itemsList.count else { return }
            guard let text = ac?.textFields?.first?.text else { return }
            if self!.checkText(text) {
                self?.itemsList.append("\(index + 1). \(text)")
                self?.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func checkText(_ text: String) -> Bool {
        let word = text.replacingOccurrences(of: "\(itemsList.count). ", with: "")
        let currentListString = itemsList.joined(separator: " ")
        
        guard !text.isEmpty else {
            showAlert(errorMessage: "Please add something! You are trying to add an empty string")
            return false
        }
        guard !currentListString.contains(word) else {
            showAlert(errorMessage: "You have already add this =)")
            return false
        }
        return true
    }
    
    func showAlert(errorMessage: String) {
        let ac = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            self?.addItem()
        }))
        present(ac, animated: true)
    }
    
    @objc func clearList() {
        itemsList.removeAll()
        tableView.reloadData()
    }
    
    @objc func shareTapped() {
        guard let title = title else { return }
        var itemsStr = title + "\n"
        itemsStr.append(itemsList.joined(separator: "\n"))
        let avc = UIActivityViewController(activityItems: [itemsStr], applicationActivities: nil)
        present(avc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = itemsList[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            itemsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

