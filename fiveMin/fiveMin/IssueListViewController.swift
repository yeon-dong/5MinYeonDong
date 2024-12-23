//
//  IssueListViewController.swift
//  fiveMin
//
//  Created by jsj on 12/19/24.
//

import UIKit
import SnapKit
import Then
import FirebaseFirestore

class IssueListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: 여기에 토픽 주제들 파이어베이스 가져오기
    let db = Firestore.firestore()
    private var topics : [Topic] = []
    
    private let Title = UILabel().then{
        $0.text = "토론했던 연동 주제들"
        $0.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
    }
    
    private let IssueListTableView = UITableView().then{
        $0.rowHeight = 60
        $0.separatorStyle = .none
    }
    
    private let ViewWrapper = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IssueListTableView.register(IssueListTableViewCell.self, forCellReuseIdentifier: "issueCell")
        IssueListTableView.dataSource = self
        IssueListTableView.delegate = self
        //getChatTopics()
        ViewWrapper.addSubview(Title)
        ViewWrapper.addSubview(IssueListTableView)
        view.addSubview(ViewWrapper)
        ViewWrapper.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(14)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-14)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        Title.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        IssueListTableView.snp.makeConstraints{
            $0.top.equalTo(Title.snp.bottom).offset(12)
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getChatTopics()
        // 뷰가 화면에 나타날 때마다 실행될 코드
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = IssueListTableView.dequeueReusableCell(withIdentifier: "issueCell", for: indexPath) as! IssueListTableViewCell
        cell.TitleLabel.text = topics[indexPath.row].title
        return cell
    }
    
    func getChatTopics(){
        db.collection("chattopics").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.topics = querySnapshot!.documents.compactMap { document in
                    let data = document.data()
                    guard let title = data["title"] as? String,
                          let messages = data["messages"] as? [Message],
                          let vote = data["vote"] as? Int,
                          let activate = data["activate"] as? Bool,
                          let startTime = data["startTime"] as? Timestamp else {
                        return nil
                    }
                    
                    // Firestore의 Timestamp를 Date로 변환
                    return Topic(
                        title: title,
                        messages: messages,
                        vote: vote,
                        activate: activate,
                        startTime: startTime.dateValue()
                    )
                }
                self.IssueListTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        IssueListTableView.deselectRow(at: indexPath, animated: false)
        let detailVC = IssueDetailViewController()
        detailVC.topic = topics[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
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
