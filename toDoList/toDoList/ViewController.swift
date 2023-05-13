//
//  ViewController.swift
//  toDoList
//
//  Created by Mustafa Gündüz on 6.05.2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
 
    
    private let table: UITableView = {
        
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
        
    }()
    
    var items = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        title = "Yapılacaklar Listesi"
        view.addSubview(table)
        table.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTabAdd))

    }
    
    
    @objc private func didTabAdd(){
        let alert = UIAlertController(title: "yeni", message: "yeni yapılacaklar", preferredStyle: .alert)
        alert.addTextField{field in field.placeholder = "buraya yazın"}
        alert.addAction(UIAlertAction(title: "iptal", style: .cancel, handler: nil ))
        alert.addAction(UIAlertAction(title: "tamam", style: .default, handler: { [weak self]
            (_) in
            if let field = alert.textFields?.first{
                if let text = field.text, !text.isEmpty {
                    
                    DispatchQueue.main.async{
                        var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        currentItems.append(text)
                        UserDefaults.standard.set(currentItems, forKey: "items")
                        self?.items.append(text)
                        self?.table.reloadData()
                    }
                    
                }
            }
        }))
        
        
        present(alert,animated: true)
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let item = items[indexPath.row]
            let sheet = UIAlertController  (title: "Are you sure?", message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                self?.items.remove(at: indexPath.row)
                var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                currentItems.remove(at: indexPath.row)
                UserDefaults.standard.setValue(currentItems, forKey: "items")
                UserDefaults.standard.removeObject(forKey: item)
                UserDefaults.standard.synchronize()
                self?.table.reloadData()
            }))
            present(sheet, animated: true)
        }
    
    

    
        override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    
    
    
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
   
    
    
}
    
    




