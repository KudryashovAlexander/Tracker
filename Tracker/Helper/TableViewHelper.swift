//
//  TableViewHelper.swift
//  Tracker
//
//  Created by Александр Кудряшов on 19.08.2023.
//

import UIKit

class TableViewHelper: UIView {
    
    private var tableCount = Int()
    private var viewForTableView = UIView()
    
    private var tableView: UITableView {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: GeneralTableViewCell.identifier)
        return tableView
    }
    

    private var tableViewColor: UIColor = .ypBackground
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableViewInView(tableCount: Int, cell: UITableViewCell) -> UIView {
        self.tableCount = tableCount

        
        
        tableView.dataSource = self
        
        viewForTableView.addSubview(tableView)
        
        
        return viewForTableView
    }
    

    
    
}

extension TableViewHelper: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        

    }
}
