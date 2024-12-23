//
//  IssueDetailViewController.swift
//  fiveMin
//
//  Created by jsj on 12/20/24.
//

import UIKit
import SnapKit
import Then
import FirebaseDatabase

class IssueDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var topic : Topic?
    private var messages : [Message] = []
    let databaseRef = Database.database().reference()
    
    private let TopicTitle = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    
    private let TopicWrapper = UIView().then{
        $0.backgroundColor = UIColor.systemGray5
        $0.layer.cornerRadius = 10
    }
    
    private let DateText = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = UIColor.systemGray4
        
    }
    
    private let ChatTableView = UITableView()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        super.viewDidLoad()
        TopicTitle.text = topic?.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        DateText.text = dateFormatter.string(from: topic!.startTime)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeMessages()
        // 뷰가 화면에 나타날 때마다 실행될 코드
    }
    
    private func observeMessages() {
        databaseRef.child("chatRooms/\(topic?.title)/messages").observe(.childAdded) { [weak self] snapshot  in
                guard let self = self else { return }
                if let data = snapshot.value as? [String: Any],
                   let senderId = data["senderId"] as? String,
                   let text = data["text"] as? String,
                   let timestamp = data["timestamp"] as? TimeInterval {
                    let message = Message(id: snapshot.key, senderId: senderId, text: text, timestamp: timestamp)
                    print(message)
                    self.messages.append(message)
                    self.ChatTableView.reloadData()
                }
            }
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatcell", for: indexPath) as! IssueTableViewCell
        let message = messages[indexPath.row].text
        let user = messages[indexPath.row].senderId
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
