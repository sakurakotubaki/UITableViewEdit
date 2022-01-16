//
//  ViewController.swift
//  UITableViewUpdate
//
//  Created by 橋本純一 on 2022/01/16.
//

import UIKit
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
}

class ItemList: Object {
    let list = List<Item>()
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let realm = try! Realm()
    var list: List<Item>!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed(_ :)))
        navigationItem.rightBarButtonItems = [editButtonItem, addBarButtonItem]
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        list = realm.objects(ItemList.self).first?.list
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realm.objects(Item.self).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = list[indexPath.row].title
        return cell
    }
    
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "新しいアイテムを追加", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "追加", style: .default) { (action) in
            let item = Item()
            item.title = textField.text!
            try! self.realm.write() {
                if self.list == nil {
                    let itemList = ItemList()
                    itemList.list.append(item)
                    self.realm.add(itemList)
                    self.list = self.realm.objects(ItemList.self).first?.list
                } else {
                    self.list.append(item)
                }
            }
            self.tableView.reloadData()
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
            try! realm.write {
                let item = list[indexPath.row]
                realm.delete(item)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //並び替え時の処理
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        try! realm.write {
            let listItem = list[fromIndexPath.row]
            list.remove(at: fromIndexPath.row)
            list.insert(listItem, at: to.row)
        }
    }

    //並び替えを可能にする
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

