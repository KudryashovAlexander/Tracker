//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 24.08.2023.
//

import UIKit

protocol ScheduleViewControllerProtocol: AnyObject {
    func updateSchedule(_ newSchedule: Schedule)
}

final class ScheduleViewController: UIViewController {
    
    private let calendar = CalendarHelper()
    var schedule = Schedule()
    weak var delegate:ScheduleViewControllerProtocol?

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
    
    private var contenSize = CGSize()
    
    private var scheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.cellIdentifier)
        tableView.isScrollEnabled = false
        tableView.separatorInset.left = 16
        tableView.separatorInset.right = 16
        tableView.backgroundColor = .ypBackground
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tableView.tableHeaderView = UIView()
        return tableView
    }()
    
    private var doneButton = UIButton().customBlackButton(title: "Готово")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        self.navigationItem.title = "Расписание"
                
        updateContentSize()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scheduleTableView)

        
        doneButton.addTarget(self, action: #selector(createSchedule), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(doneButton)
       
        layoutSupport()
        
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
    }
    
    private func layoutSupport() {
        NSLayoutConstraint.activate([

            scheduleTableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            scheduleTableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            scheduleTableView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32),
            scheduleTableView.heightAnchor.constraint(equalToConstant: 75*7),
            
            doneButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            doneButton.widthAnchor.constraint(equalToConstant: contentView.frame.width - 40),
            doneButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func updateContentSize() {
        let heighElement: CGFloat = CGFloat(integerLiteral: 24 + calendar.dayNameOfWeek.count * 75 + 24 + 60 + 16)
        let viewHeight = view.bounds.height - 148
        let maxView = heighElement > viewHeight ? heighElement : viewHeight
        contenSize = CGSize(width: view.frame.width, height: maxView)
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
        calendar.dayNumber.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = scheduleTableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.cellIdentifier, for: indexPath) as?  ScheduleTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.selectionStyle = .none
        let dayName = calendar.dayNameOfWeek[indexPath.row]
        let numberDay = calendar.dayNumber[indexPath.row]
        let isOn = schedule.daysOn.contains(calendar.dayNumber[indexPath.row])
        
        cell.configure(text: dayName,
                       numberDay: numberDay,
                       isOn: isOn)
        
        cell.backgroundColor = .ypBackground
        return cell
    }
    
}

//MARK: Extension ScheduleViewControllerProtocol
extension ScheduleViewController: ScheduleTableViewCellProtocol {
    func changeIsOn(_ numberDay: Int) {
        if schedule.daysOn.contains(numberDay) {
            schedule.daysOn.remove(numberDay)
        } else {
            schedule.daysOn.insert(numberDay)
        }
    }
}
