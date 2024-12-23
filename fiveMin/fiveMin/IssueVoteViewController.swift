//
//  IssueVoteViewController.swift
//  fiveMin
//
//  Created by jsj on 12/19/24.
//

import UIKit
import SnapKit
import Then
import FirebaseFirestore

class IssueVoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    let db = Firestore.firestore()
    var topicList : [Topic] = []
    var bestTopic : Topic?
    
    private let ContainerView = UIView()
    
    private let Title = UILabel().then{
        $0.text = "다음 주제를 투표해주세요!"
        $0.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
    }
    
    private let BestTopicWrapper = UIView().then{
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 10
    }
    
    private let BestTopicText = UILabel().then{
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.text = "👑현재 가장 유력한 다음 연동 주제👑"
    }
    
    private let BestTopicTitle = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .black
    }
    
    private let BestTopicTitleWrapper = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    private let BestTopicBottomImageView = UIImageView().then{
        $0.image = UIImage.init(systemName: "hand.thumbsup.fill")
        $0.tintColor = .white
    }
    
    private let BestTopicBottomTextView = UILabel().then{
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    private let IssueListTableView = UITableView().then{
        $0.separatorStyle = .none
        $0.rowHeight = 100
    }
    
    private let TopicinputField = UITextField().then{
        $0.borderStyle = .roundedRect
        $0.placeholder = "의견을 나누고 싶은 주제를 등록해보세요!"
    }
    
    private let SendButton = UIButton(type: .custom).then{
        $0.setTitle("등록하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 10
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: 여기에 파이어베이스에 불러온 토픽 리스트 삽입
        topicList = []
        bestTopic = topicList.max(by:{$0.vote < $1.vote})
        if let bestTopic {
            BestTopicTitle.text = "\(bestTopic.title)"
            BestTopicBottomTextView.text = "\(bestTopic.vote)개의 좋아요"
        } else {
            BestTopicTitle.text =  "아직 토픽이 없습니다."
            BestTopicBottomTextView.text = "그러면 좋아요도 없습니다."
        }
        let views = [Title, BestTopicWrapper, IssueListTableView, TopicinputField, SendButton]
        views.forEach{
            ContainerView.addSubview($0)
        }
        BestTopicWrapper.addSubview(BestTopicText)
        BestTopicTitleWrapper.addSubview(BestTopicTitle)
        BestTopicWrapper.addSubview(BestTopicTitleWrapper)
        BestTopicWrapper.addSubview(BestTopicBottomImageView)
        BestTopicWrapper.addSubview(BestTopicBottomTextView)
        view.addSubview(ContainerView)
        
        IssueListTableView.dataSource = self
        IssueListTableView.delegate = self
        IssueListTableView.register(IssueVoteTableViewCell.self, forCellReuseIdentifier: "votecell")
        
        ContainerView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(14)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-14)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        Title.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        BestTopicWrapper.snp.makeConstraints{
            $0.top.equalTo(Title.snp.bottom).offset(5)
            $0.bottom.equalTo(BestTopicBottomTextView.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        BestTopicText.snp.makeConstraints{
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        
        BestTopicTitleWrapper.snp.makeConstraints{
            $0.top.equalTo(BestTopicText.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(90)
        }
        
        BestTopicTitle.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
        
        BestTopicBottomImageView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalTo(BestTopicTitleWrapper.snp.bottom).offset(10)
        }
        
        BestTopicBottomTextView.snp.makeConstraints{
            $0.leading.equalTo(BestTopicBottomImageView.snp.trailing)
            $0.top.equalTo(BestTopicTitleWrapper.snp.bottom).offset(10)
        }
        
        IssueListTableView.snp.makeConstraints{
            $0.top.equalTo(BestTopicWrapper.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        SendButton.snp.makeConstraints{
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-14)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        TopicinputField.snp.makeConstraints{
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(14)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.trailing.equalTo(SendButton.snp.leading).offset(-3)
        }
        fetchTopics()
        SendButton.addTarget(self, action:#selector(sendTopic), for : .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(createChatting))
        BestTopicWrapper.addGestureRecognizer(tapGesture)
        BestTopicWrapper.isUserInteractionEnabled = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = IssueListTableView.dequeueReusableCell(withIdentifier: "votecell", for: indexPath) as! IssueVoteTableViewCell
        cell.TitleLabel.text = topicList[indexPath.row].title
        let vote = topicList[indexPath.row].vote
        vote != 0 ? (cell.VoteLabel.text = "\(String(describing: vote))개의 좋아요") : (cell.VoteLabel.text = "아직 좋아요가 없습니다.")
        return cell
    }
    
    //MARK: 여기에 토픽 주제 등록이랑 파이어베이스 연동
    //토픽 등록 함수
    @objc private func sendTopic(){
        guard let topic = TopicinputField.text, !topic.isEmpty else {return}
        
        let newTopic = Topic(title: topic, messages: [], vote: 0, activate: false, startTime: Date())
        db.collection("topics").addDocument(data: newTopic.toDictionary()){ error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
            }
        }
        fetchTopics()
        TopicinputField.text = ""
    }
    
    @objc private func createChatting(){
        guard let topic = bestTopic else {
            return
        }
        TopicManager.shared.setActiveTopic(topic)
        deleteTopic(title: topic.title)
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0
            NotificationCenter.default.post(name: NSNotification.Name("UIUpdateNotification"), object: nil)
        }
    }
    
    func fetchTopics() {
        db.collection("topics").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.topicList = querySnapshot!.documents.compactMap { document in
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
                print(self.topicList)
                self.reloadData()
            }
        }
    }
    
    func deleteTopic(title: String){
        db.collection("topics")
                    .whereField("title", isEqualTo: title)
                    .getDocuments { snapshot, error in
                        if let error = error {
                            print("Error getting documents: \(error)")
                            return
                        }
                        // 문서가 존재하는 경우 삭제
                        if let snapshot = snapshot, !snapshot.isEmpty {
                            for document in snapshot.documents {
                                // 문서 삭제
                                document.reference.delete() { error in
                                    if let error = error {
                                        print("Error removing document: \(error)")
                                    } else {
                                        self.sendChattingTopic(title: title)
                                        self.fetchTopics()
                                    }
                                }
                            }
                            
                        } else {
                            print("No topic found with the title \(title).")
                        }
                    }
    }
    
    private func sendChattingTopic(title: String){
        let newChatTopic = Topic(title: title, messages: [], vote: 0, activate: false, startTime: Date())
        db.collection("chattopics").addDocument(data: newChatTopic.toDictionary()){ error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
            }
        }
        TopicinputField.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

            let currentText = textField.text ?? ""
            guard let textRange = Range(range, in: currentText) else { return true }
            let updatedText = currentText.replacingCharacters(in: textRange, with: string)
            
            return updatedText.count <= 40
        }
    // MARK: 여기에 좋아요랑 파이어베이스 연동
    //좋아요 증가시키는 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let topicRef = db.collection("topics").whereField("title", isEqualTo: topicList[indexPath.row].title)
        // vote 증가
                topicRef.getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting document: \(error)")
                    } else {
                        if let document = querySnapshot?.documents.first {
                            let currentVote = document.data()["vote"] as? Int ?? 0
                            let updatedVote = currentVote + 1
                            
                            // 해당 문서의 vote 필드 업데이트
                            document.reference.updateData(["vote": updatedVote]) { error in
                                if let error = error {
                                    print("Error updating document: \(error)")
                                } else {
                                    // 테이블 뷰 새로 고침
                                    self.fetchTopics() // 새로운 데이터를 다시 불러와서 테이블 뷰 갱신
                                }
                            }
                        }
                    }
                }
    }
    
    func reloadData(){
        IssueListTableView.reloadData()
        bestTopic = topicList.max(by:{$0.vote < $1.vote})
        if let bestTopic {
            BestTopicTitle.text = "\(bestTopic.title)"
            BestTopicBottomTextView.text = "\(bestTopic.vote)개의 좋아요"
        } else {
            BestTopicTitle.text =  "아직 토픽이 없습니다."
            BestTopicBottomTextView.text = "그러면 좋아요도 없습니다."
        }
    }
    

}
