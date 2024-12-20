//
//  MainViewController.swift
//  fiveMin
//
//  Created by jsj on 12/19/24.
//

import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let viewControllersList: [UIViewController] = [
            IssueChatViewController(),
            IssueListViewController(),
            IssueVoteViewController()
        ]
        
        let iconList = [
            UIImage(named: "home_icon")?.withRenderingMode(.alwaysOriginal), // 기본 이미지
            UIImage(systemName: "list.bullet"),
            UIImage(systemName: "bubble")
        ]
        
        viewControllersList.enumerated().forEach { (index, item) in
            item.tabBarItem = UITabBarItem(title: "", image: iconList[index], tag: index)
        }
        
        var navigationControllers: [UINavigationController] = []
        viewControllersList.forEach {
            navigationControllers.append(UINavigationController(rootViewController: $0))
        }
        
        self.viewControllers = navigationControllers
        self.tabBar.backgroundColor = .systemGray4
        
        // 탭 바의 tintColor 설정
        self.tabBar.tintColor = .systemBlue // 선택된 아이콘의 색상
        self.tabBar.unselectedItemTintColor = .gray // 선택되지 않은 아이콘의 색상
        
        // UITabBarControllerDelegate 설정
        self.delegate = self
    }

    // 탭 아이템 선택 시 호출되는 메서드
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateTabBarIcons()
    }

    // 탭 아이콘 업데이트 메서드
    private func updateTabBarIcons() {
        guard let items = tabBar.items else { return }
        
        // 첫 번째 탭 아이콘만 변경
        if let firstItem = items.first {
            if selectedIndex == 0 {
                // 첫 번째 탭이 선택된 경우
                firstItem.image = UIImage(named: "home_icon")?.withRenderingMode(.alwaysOriginal)
            } else {
                // 첫 번째 탭이 선택되지 않은 경우
                firstItem.image = UIImage(named: "home_icon2")?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
}
