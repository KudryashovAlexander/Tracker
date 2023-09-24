//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 06.08.2023.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    private let viewModel: StatisticViewModel
    
    private let emptyImageView: UIImageView = {
        let image = UIImage(named: "noStatistic") ?? UIImage()
        let imageView = UIImageView(image: image)
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.font = .yPMedium12
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.text = String().statisticEmptyLabel
        label.backgroundColor = .ypWhite
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .ypWhite
        scrollView.frame = view.bounds
        scrollView.contentSize = contenSize
        scrollView.isHidden = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.frame.size = contenSize
        view.backgroundColor = .ypWhite
        return view
    }()
    
    private var contenSize = CGSize()
    
    private lazy var bestPeriodView: UIView = {
        let view = StaticticSubView(viewModel: viewModel.statisticsVM[0])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bestDaysView: UIView = {
        let view = StaticticSubView(viewModel: viewModel.statisticsVM[1])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var trackerCompletedView: UIView = {
        let view = StaticticSubView(viewModel: viewModel.statisticsVM[2])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var averageView: UIView = {
        let view = StaticticSubView(viewModel: viewModel.statisticsVM[3])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init (viewModel:StatisticViewModel ) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        updateContentSize()
        self.navigationItem.title = String().mainStatistic
        navigationController?.navigationBar.prefersLargeTitles = true
        
        statisticIsEmpty(viewModel.statisticIsEmpty)
        layoutSupport()
        bind()
    }
    
    private func updateContentSize() {
        let heightElement = 24 + (90 * 4) + 12*3 + 24
        contenSize = CGSize(width: view.frame.width, height: CGFloat(heightElement))
        scrollView.contentSize = contenSize
        contentView.frame.size = contenSize
    }
    
    private func layoutSupport() {
        view.addSubview(emptyImageView)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            emptyImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 8)
        ])
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 444)
        ])
        
        contentView.addSubview(bestPeriodView)
        contentView.addSubview(bestDaysView)
        contentView.addSubview(trackerCompletedView)
        contentView.addSubview(averageView)
        
        NSLayoutConstraint.activate([
            bestPeriodView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 77),
            bestPeriodView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            bestPeriodView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            
            bestDaysView.topAnchor.constraint(equalTo: bestPeriodView.bottomAnchor, constant: 12),
            bestDaysView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            bestDaysView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            
            trackerCompletedView.topAnchor.constraint(equalTo: bestDaysView.bottomAnchor, constant: 12),
            trackerCompletedView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            trackerCompletedView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            
            averageView.topAnchor.constraint(equalTo: trackerCompletedView.bottomAnchor, constant: 12),
            averageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            averageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
        ])
        view.layoutIfNeeded()
    }
    
    private func bind() {
        viewModel.$statisticIsEmpty.bind { [weak self] isEmpty in
            self?.statisticIsEmpty(isEmpty)
        }
    }
    
    private func statisticIsEmpty(_ isEmpty: Bool) {
        emptyImageView.isHidden = !isEmpty
        emptyLabel.isHidden = !isEmpty
        scrollView.isHidden = isEmpty
    }
    
}
