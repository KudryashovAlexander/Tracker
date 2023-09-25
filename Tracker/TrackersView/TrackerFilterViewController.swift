//
//  TrackerFilterViewController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 25.09.2023.
//

import UIKit

protocol TrackerFilterViewControllerDelegate: AnyObject {
    func changeFilter(newFilter: Int)
}

class TrackerFilterViewController: UIViewController {
    
    private let filterName = [String().filterAllTracker,
                              String().filterTrackerToday,
                              String().filterComplated,
                              String().filterNotComplated]
    
    var selectedFilter = 1
    weak var delegate:TrackerFilterViewControllerDelegate?
    
    private var filterTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TrackerFilterViewCell.self, forCellReuseIdentifier: TrackerFilterViewCell.cellIdentifier)
        tableView.isScrollEnabled = false
        tableView.allowsMultipleSelection = false
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.tableHeaderView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        self.navigationItem.title = String().mainFilter
        modalPresentationStyle = .none

        layoutSupport()
        
        filterTableView.dataSource = self
        filterTableView.delegate = self
    }
    
    func layoutSupport() {
        view.addSubview(filterTableView)
        
        NSLayoutConstraint.activate([
            filterTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            filterTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
            filterTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            filterTableView.heightAnchor.constraint(equalToConstant: 75 * 4)
        ])
        
    }
    
}
//MARK: - Extension UITableViewDataSource, UITableViewDelegate
extension TrackerFilterViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = filterTableView.dequeueReusableCell(withIdentifier: TrackerFilterViewCell.cellIdentifier, for: indexPath) as? TrackerFilterViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.backgroundColor = .ypBackground
        cell.configure(name: filterName[indexPath.row])
        if indexPath.row == selectedFilter {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            cell.configureIsSelected(true)
        } else {
            cell.configureIsSelected(false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = filterTableView.cellForRow(at: indexPath) as? TrackerFilterViewCell else { return }
        cell.configureIsSelected(true)
        delegate?.changeFilter(newFilter: indexPath.row)
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = filterTableView.cellForRow(at: indexPath) as? TrackerFilterViewCell else { return }
        cell.configureIsSelected(false)
    }
    
}

