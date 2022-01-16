//
//  ViewController.swift
//  UITableViewUpdate
//
//  Created by 橋本純一 on 2022/01/16.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var languages: [String] = ["Swift", "Java", "Ruby", "Javascript", "PHP"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed(_ :)))
        navigationItem.rightBarButtonItems = [editButtonItem, addBarButtonItem]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = languages[indexPath.row]
        return cell
    }
    
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "新しいアイテムを追加", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "追加", style: .default) { (action) in
            self.languages.append(textField.text!)
            self.tableView.reloadData()
            print(self.languages)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "アイテムを入力"
            textField = alertTextField
        }
            
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        tableView.isEditing = editing
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            languages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print(languages)
        }
    }
    
    //並び替え時の処理
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let language = languages[fromIndexPath.row]
        languages.remove(at: fromIndexPath.row)
        languages.insert(language, at: to.row)
        print(languages)
    }

    //並び替えを可能にする
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

