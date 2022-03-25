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
        CustomTableViewModel(title: "1111", cellDsc: "第1条数据"),
        CustomTableViewModel(title: "2222", cellDsc: "第2条数据"),
        CustomTableViewModel(title: "3333", cellDsc: "第3条数据"),
        CustomTableViewModel(title: "4444", cellDsc: "第4条数据"),
        CustomTableViewModel(title: "5555", cellDsc: "第5条数据"),
        CustomTableViewModel(title: "6666", cellDsc: "第6条数据"),
        CustomTableViewModel(title: "7777", cellDsc: "第7条数据"),
        CustomTableViewModel(title: "8888", cellDsc: "第8条数据"),
        CustomTableViewModel(title: "9999", cellDsc: "第9条数据"),
        CustomTableViewModel(title: "0000", cellDsc: "第10条数据"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "CustomTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 下面两种方案择一执行
        forAsynchronous() // 法一：使用Task + async/await实现的异步
        // forGCDThread() // 法二：使用GCD实现的次线程
    }
    
    func forGCDThread()  {
        DispatchQueue(label: "UpdateTableView").asyncAfter(deadline: .now() + 1) {
            Thread.sleep(forTimeInterval: 1)
            for _ in 0 ..< 3 {
                self.updateTableViewWithGCD()
            }
        }
    }
    
    func forAsynchronous() {
        Task(priority: .background) {
            try await Task.sleep(nanoseconds: UInt64(1e9))
            for _ in 0 ..< 3 {
                try await self.updateTableViewWithTask()
            }
        }
    }

    func updateTableViewWithGCD() {
        addCellsWithGCD()
        Thread.sleep(forTimeInterval: 0.5)
        deleteCellsWithGCD()
        Thread.sleep(forTimeInterval: 0.5)
        moveCellsWithGCD()
        Thread.sleep(forTimeInterval: 0.5)
    }
    
    func updateTableViewWithTask() async throws {
        NSLog("\(Thread.current) \(Thread.isMainThread)")
        await addCellsWithTask()
        try await Task.sleep(nanoseconds: UInt64(5e8))
        await deleteCellsWithTask()
        try await Task.sleep(nanoseconds: UInt64(5e8))
        await moveCellsWithTask()
        try await Task.sleep(nanoseconds: UInt64(5e8))
    }
    
    let newCellModels = [
        CustomTableViewModel(title: "aaaa", cellDsc: "新增数据1"),
        CustomTableViewModel(title: "bbbb", cellDsc: "新增数据2"),
        CustomTableViewModel(title: "cccc", cellDsc: "新增数据3"),
    ]
    
    func addCellsWithGCD() {
        let offset = cellModels.count > 2 ? 2 : cellModels.count
        DispatchQueue.main.async {
            self.cellModels.insert(contentsOf: self.newCellModels, at: offset)
            print(self.cellModels.map {"\($0)"}.joined(separator: "\n"))
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: (offset ..< offset + self.newCellModels.count).map {IndexPath(item: $0, section: 0)}, with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    func addCellsWithTask() async {
        let offset = cellModels.count > 2 ? 2 : cellModels.count
        let _ = await Task {
            self.cellModels.insert(contentsOf: newCellModels, at: offset)
            print(cellModels.map {"\($0)"}.joined(separator: "\n"))
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: (offset ..< offset + newCellModels.count).map {IndexPath(item: $0, section: 0)}, with: .automatic)
            self.tableView.endUpdates()
        }.result
    }
    
    func deleteCellsWithGCD() {
        if cellModels.isEmpty { return }
        let atIndex = cellModels.count > 3 ? 3 : cellModels.endIndex - 1
        DispatchQueue.main.async {
            self.cellModels.remove(at: atIndex)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [IndexPath(item: atIndex, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    func deleteCellsWithTask() async {
        if cellModels.isEmpty { return }
        let atIndex = cellModels.count > 3 ? 3 : cellModels.endIndex - 1
        let _ = await Task {
            self.cellModels.remove(at: atIndex)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [IndexPath(item: atIndex, section: 0)], with: .automatic)
            self.tableView.endUpdates()
        }.result
    }
    
    func moveCellsWithGCD() {
        let from = cellModels.count > 3 ? 1 : cellModels.startIndex
        let to = cellModels.count > 3 ? 3 : cellModels.endIndex - 1
        if to <= from { return }
        DispatchQueue.main.async {
            let tempModel = self.cellModels.remove(at: from)
            self.cellModels.insert(tempModel, at: to)
            self.tableView.beginUpdates()
            self.tableView.moveRow(at: IndexPath(item: from, section: 0), to: IndexPath(item: to, section: 0))
            self.tableView.endUpdates()
        }
    }
    
    func moveCellsWithTask() async {
        let from = cellModels.count > 3 ? 1 : cellModels.startIndex
        let to = cellModels.count > 3 ? 3 : cellModels.endIndex - 1
        if to <= from { return }
        let _ = await Task {
            let tempModel = self.cellModels.remove(at: from)
            self.cellModels.insert(tempModel, at: to)
            self.tableView.beginUpdates()
            self.tableView.moveRow(at: IndexPath(item: from, section: 0), to: IndexPath(item: to, section: 0))
            self.tableView.endUpdates()
        }.result
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
