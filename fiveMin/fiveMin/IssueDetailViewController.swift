//
//  IssueDetailViewController.swift
//  fiveMin
//
//  Created by jsj on 12/20/24.
//

import UIKit
import SnapKit
import Then

class IssueDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var topic : Topic?
    
    private let TopicTitle = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    
    private let TopicWrapper = UIView().then{
        $0.backgroundColor = UIColor.systemGray5
        $0.layer.cornerRadius = 10
    }
    
    private let DateText = UILabel().then{
        $0.text = "시간"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = UIColor.systemGray4
        
    }
    
    private let ChatTableView = UITableView()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        super.viewDidLoad()
        TopicTitle.text = topic?.title
        ChatTableView.register(IssueTableViewCell.self, forCellReuseIdentifier: "chatcell")
        ChatTableView.delegate = self
        ChatTableView.dataSource = self
        TopicWrapper.addSubview(TopicTitle)
        let views = [TopicWrapper, ChatTableView, DateText]
        views.forEach{
            view.addSubview($0)
        }
        
        TopicWrapper.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(14)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(14)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-14)
            $0.height.equalTo(54)
        }
        TopicTitle.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(TopicWrapper.snp.leading).offset(16)
        }
        DateText.snp.makeConstraints{
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-14)
            $0.top.equalTo(TopicWrapper.snp.bottom).offset(5)
        }
        ChatTableView.snp.makeConstraints{
            $0.top.equalTo(DateText.snp.bottom).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalTo(view.safeAreaLayoutGuide)
        }

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topic?.messages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatcell", for: indexPath) as! IssueTableViewCell
        let message = topic?.messages[indexPath.row].text
        let user = topic?.messages[indexPath.row].senderId
        cell.TitleLabel.text = user
        cell.ContentLabel.text = message
        return cell
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
