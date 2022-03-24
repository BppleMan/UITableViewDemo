//
//  ViewController.swift
//  UITableDemo
//
//  Created by BppleMan on 2022/3/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var cellModels = [
        CustomTableViewModel(title: "张三", cellDsc: "一个人"),
        CustomTableViewModel(title: "李四", cellDsc: "一个人"),
        CustomTableViewModel(title: "张三", cellDsc: "一个人"),
        CustomTableViewModel(title: "李四", cellDsc: "一个人"),
        CustomTableViewModel(title: "张三", cellDsc: "一个人"),
        CustomTableViewModel(title: "李四", cellDsc: "一个人"),
        CustomTableViewModel(title: "张三", cellDsc: "一个人"),
        CustomTableViewModel(title: "李四", cellDsc: "一个人"),
        CustomTableViewModel(title: "张三", cellDsc: "一个人"),
        CustomTableViewModel(title: "李四", cellDsc: "一个人"),
        CustomTableViewModel(title: "张三", cellDsc: "一个人"),
        CustomTableViewModel(title: "李四", cellDsc: "一个人"),
        CustomTableViewModel(title: "张三", cellDsc: "一个人"),
        CustomTableViewModel(title: "李四", cellDsc: "一个人"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CustomTableViewCell")
    }

    @IBAction func addCells(_ sender: Any) {
        let newCellModels = [
            CustomTableViewModel(title: "王五", cellDsc: "一个人"),
            CustomTableViewModel(title: "赵铁柱", cellDsc: "一个人"),
            CustomTableViewModel(title: "李建国", cellDsc: "一个人"),
        ]
        tableView.beginUpdates()
        let offset = cellModels.count > 2 ? 2 : cellModels.count
        cellModels.insert(contentsOf: newCellModels, at: offset)
        tableView.insertRows(at: (offset ..< offset + newCellModels.count).map {IndexPath(item: $0, section: 0)}, with: .automatic)
        tableView.endUpdates()
    }
    
    @IBAction func deleteCells(_ sender: Any) {
        if cellModels.isEmpty { return }
        tableView.beginUpdates()
        let atIndex = cellModels.count > 3 ? 3 : cellModels.endIndex - 1
        print(atIndex)
        cellModels.remove(at: atIndex)
        tableView.deleteRows(at: [IndexPath(item: atIndex, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    @IBAction func moveCells(_ sender: Any) {
        let from = cellModels.count > 3 ? 1 : cellModels.startIndex
        let to = cellModels.count > 3 ? 3 : cellModels.endIndex - 1
        if to <= from { return }
        tableView.beginUpdates()
        let tempModel = cellModels.remove(at: from)
        cellModels.insert(tempModel, at: to)
        tableView.moveRow(at: IndexPath(item: from, section: 0), to: IndexPath(item: to, section: 0))
        tableView.endUpdates()
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath)
        var cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell
        if cell == nil {
            cell = CustomTableViewCell(style: .default, reuseIdentifier: "CustomTableViewCell")
        }
        cell!.title.text = cellModels[indexPath.item].title
        cell!.cellDescription.text = cellModels[indexPath.item].cellDsc
        return cell!
    }
}
