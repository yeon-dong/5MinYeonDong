//
//  IssueVoteViewController.swift
//  fiveMin
//
//  Created by jsj on 12/19/24.
//

import UIKit
import SnapKit
import Then

class IssueVoteViewController: UIViewController {

    private let Title = UILabel().then{
        $0.text = "다음 주제를 투표해주세요!"
    }
    
    private let BestTopicWrapper = UIView().then{
        $0.backgroundColor = .systemBlue
    }
    
    private let BestTopicTitle = UILabel().then{
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
    }
    private let IssueListTableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BestTopicTitle.text = "👑주제👑"
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
