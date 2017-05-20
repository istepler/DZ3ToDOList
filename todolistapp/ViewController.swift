//
//  ViewController.swift
//  ToDoListApp
//
//  Created by Kirill Kirikov on 5/14/17.
//  Copyright © 2017 GoIT. All rights reserved.
//

import UIKit

private enum ToDoItemPriority:Int {
    case normal
    case low
    case high
    
    func color() -> UIColor {
        switch self {
        case .high:
            return .red
        case .low:
            return .blue
        case .normal:
            return UIColor(red: 5/255, green: 225/255, blue: 119/255, alpha: 1)
        }
    }
}

private protocol ToDoItem {
    var title:String {
        get
    }
    
    var priority:ToDoItemPriority {
        get
    }
    
    var icon:UIImage {
        get
    }
}

private class BaseToDoItem: NSObject, ToDoItem, NSCoding {
    
    var icon: UIImage {
        get {
            return #imageLiteral(resourceName: "icon_0")
        }
    }
    
    var title: String
    var priority: ToDoItemPriority
    
    init(title: String, priority: ToDoItemPriority) {
        self.title = title
        self.priority = priority
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: "title") as? String ?? ""
        self.priority = ToDoItemPriority(rawValue: aDecoder.decodeInteger(forKey: "priority"))!
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(priority.rawValue, forKey: "priority")
    }
}

private class ClassworkToDoItem: BaseToDoItem {
    override var icon: UIImage {
        get {
            return #imageLiteral(resourceName: "icon_2")
        }
    }
}

private class HomeworkToDoItem: BaseToDoItem {
    override var icon: UIImage {
        get {
            return #imageLiteral(resourceName: "icon_0")
        }
    }
}

private class GameToDoItem: BaseToDoItem {
    override var icon: UIImage {
        get {
            return #imageLiteral(resourceName: "icon_1")
        }
    }
}


private class TodoItemsDataSource: NSObject, UITableViewDataSource {
    
    fileprivate var items:[ToDoItem] = []
    
    override init() {
        super.init()
        load()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("NumberOfRowsInSetion: \(section)")
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("CellForRowAt: \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ToDoItemTableViewCell
        
        cell.titleLabel.text = items[indexPath.row].title
        cell.priorityView.backgroundColor = items[indexPath.row].priority.color()
        cell.iconImageView.image = items[indexPath.row].icon
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func addItem(item: ToDoItem) {
        items.append(item)
        save()
    }
    
    func load() {
        guard let loadedData = NSKeyedUnarchiver.unarchiveObject(withFile: "/Developer/projects/ToDoList.bin") as? [ToDoItem] else {
            return
        }
        items = loadedData
    }
    
    func save() {
        let result = NSKeyedArchiver.archiveRootObject(items, toFile: "/Developer/projects/ToDoList.bin")
        print("Archive Result: \(result)")
    }
}

class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    private let dataSource = TodoItemsDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addNewClassworkItem(_ sender: UIButton) {
        let item = ClassworkToDoItem(title: "New Item", priority: .high)
        dataSource.addItem(item: item)
        tableView.reloadData()
    }
}

