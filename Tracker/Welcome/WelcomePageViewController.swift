//
//  WelcomePageViewController.swift
//  Tracker
//
//  Created by Александр Кудряшов on 05.08.2023.
//

import UIKit

final class WelcomePageViewController: UIPageViewController {
    
    private let pressButton = UIButton().customBlackButton(title: "Вот это технологии!")
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = .ypLightGray.withAlphaComponent(0.3)
        return pageControl
    }()
    
    private let textArray = ["Отслеживайте только то, что хотите",
                                """
                                Даже если это
                                не литры воды и йога
                                """]
    
    private let nameImageView = ["background1",
                                 "background2"]
    
    private lazy var pages: [UIViewController] = {
        let vc0 = WelcomeViewController(labelText: textArray[0], imageName: nameImageView[0])
        let vc1 = WelcomeViewController(labelText: textArray[1], imageName: nameImageView[1])
        return [vc0, vc1]
    }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: nil)
        
        setViewControllers([pages[0]],
                           direction: .forward,
                           animated: true,
                           completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init not been impletion")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .overFullScreen
        
        view.addSubview(pressButton)
        pressButton.addTarget(self,
                         action: #selector(clickButton),
                         for: .touchUpInside)
        pressButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        self.delegate = self
        self.dataSource = self
        
        layoutSupport()
    }
    
    @objc
    private func clickButton() {
        let tabBar = TabBarController()
        UserDefaults.standard.set(UserProfile.joinSuccess, forKey: UserProfile.joinSuccess)
        self.present(tabBar, animated: true)
    }
    
    private func pageControlSupport() {
        pageControl.numberOfPages = textArray.count
        view.addSubview(pageControl)
    }
    
    private func layoutSupport() {
        NSLayoutConstraint.activate([
            pressButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            pressButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            pressButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            pressButton.heightAnchor.constraint(equalToConstant: 60),
            
            pageControl.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: pressButton.topAnchor, constant: -24)
        ])
    }
}

//MARK: - Exension
extension WelcomePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return pages.last
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return pages.first
        }
        return pages[nextIndex]
    }
    
}


//MARK: - Extension
extension WelcomePageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
    
}


