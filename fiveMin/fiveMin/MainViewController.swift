//
//  MainViewController.swift
//  fiveMin
//
//  Created by jsj on 12/19/24.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let viewControllersList : [UIViewController] = [IssueChatViewController(),IssueListViewController(),IssueVoteViewController()]
        let iconList = [UIImage(systemName: "house"), UIImage(systemName: "list.bullet"), UIImage(systemName: "bubble")]
        viewControllersList.enumerated().forEach{ (index, item) in
            item.tabBarItem = UITabBarItem(title:"",image:iconList[index], tag: index)
        }
        var navigationControllers : [UINavigationController] = []
        viewControllersList.forEach{
            navigationControllers.append(UINavigationController(rootViewController: $0))
        }
        self.viewControllers = navigationControllers
        self.tabBar.backgroundColor = .systemGray4
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
