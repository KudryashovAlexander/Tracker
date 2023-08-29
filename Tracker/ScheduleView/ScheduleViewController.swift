//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 24.08.2023.
//

import UIKit

protocol ScheduleViewControllerProtocol {
    func updateSchedule(_ newSchedule: Schedule)
}

final class ScheduleViewController: UIViewController {
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhite
        scrollView.frame = view.bounds
        scrollView.contentSize = contenSize
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.frame.size = contenSize
        view.backgroundColor = .ypWhite
        return view
    }()
    
    private var contenSize: CGSize{
        return CGSize(width: view.frame.width, height: 24 + 75*7 + 24 + 60)
    }
    
    private var scheduleContainer = UIView()
    private var scheduleTableView = UITableView()
    private var schedule = Schedule()
    private var doneButton = UIButton()
    
    var delegate:ScheduleViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        self.navigationItem.title = "Расписание"
        
        scheduleContainerSupport()
        scheduleTableViewSupport()
        doneButtonSupport()
        
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self

        layoutSupport()
        
    }
    
    private func layoutSupport() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scheduleContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scheduleContainer)
        
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        scheduleContainer.addSubview(scheduleTableView)
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            scheduleContainer.widthAnchor.constraint(equalToConstant: contentView.frame.width - 16 * 2),
            scheduleContainer.heightAnchor.constraint(equalToConstant: 75 * 7),
            scheduleContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            scheduleContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            scheduleTableView.topAnchor.constraint(equalTo: scheduleContainer.topAnchor),
            scheduleTableView.bottomAnchor.constraint(equalTo: scheduleContainer.bottomAnchor),
            scheduleTableView.leftAnchor.constraint(equalTo: scheduleContainer.leftAnchor),
            scheduleTableView.rightAnchor.constraint(equalTo: scheduleContainer.rightAnchor),
            
            doneButton.topAnchor.constraint(equalTo: scheduleContainer.bottomAnchor, constant: 24),
            doneButton.widthAnchor.constraint(equalToConstant: contentView.frame.width - 40),
            doneButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func scheduleContainerSupport() {
        scheduleContainer.backgroundColor = .ypBackground
        scheduleContainer.layer.masksToBounds = true
        scheduleContainer.layer.cornerRadius = 16
    }
    
    private func scheduleTableViewSupport() {
        scheduleTableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.cellIdentifier)
        scheduleTableView.isScrollEnabled = false
        scheduleTableView.separatorInset.left = 16
        scheduleTableView.separatorInset.right = 16
        scheduleTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        scheduleTableView.tableHeaderView = UIView()
    }
    
    private func doneButtonSupport() {
        doneButton.backgroundColor = .ypBlack
        doneButton.setTitle("Готово", for: .normal)
        doneButton.layer.masksToBounds = true
        doneButton.layer.cornerRadius = 16
        doneButton.addTarget(self, action: #selector(createSchedule), for: .touchUpInside)
    }
    
    @objc
    private func createSchedule() {
        delegate?.updateSchedule(schedule)
        dismiss(animated: true)
    }
    
}

//MARK: - Extension UITableViewDataSource, UITableViewDelegate
extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        schedule.daysIsOn.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = scheduleTableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.cellIdentifier, for: indexPath) as?  ScheduleTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        
        cell.dayLabel.text = schedule.dayOfWeek[indexPath.row]
        cell.daySwitch.isOn = schedule.daysIsOn[indexPath.row].isOn
        cell.numberDay = indexPath.row
        
        cell.backgroundColor = .ypBackground
        return cell
    }
    
}

//MARK: Extension ScheduleViewControllerProtocol
extension ScheduleViewController: ScheduleTableViewCellProtocol {
    func changeIsOn(_ numberDay: Int) {
        schedule.daysIsOn[numberDay].isOn = !schedule.daysIsOn[numberDay].isOn
    }
}
