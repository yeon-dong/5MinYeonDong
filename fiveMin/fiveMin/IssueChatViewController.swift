//
//  IssueChatViewController.swift
//  fiveMin
//
//  Created by jsj on 12/19/24.
//

import UIKit
import SnapKit
import Then
import FirebaseDatabase
import FirebaseFirestore


class IssueChatViewController: UIViewController,  UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    private var messages : [Message] = []
    var topic :Topic?
    let db = Firestore.firestore()
    let databaseRef = Database.database().reference()
    

    private let Title = UILabel().then{
        $0.text = "지금의 연동 주제"
        $0.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
    }
    
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
    
    private let NameInputField = UITextField().then{
        $0.borderStyle = .roundedRect
        $0.placeholder = "닉네임"
    }
    
    private let ChatInputField = UITextField().then{
        $0.borderStyle = .roundedRect
        $0.placeholder = "주제에 대한 자신의 의견을 말해보세요!"
    }
    
    private let SendButton = UIButton(type: .custom).then{
        $0.setTitle("등록하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getActiveTopicFromServer()
        topic  = TopicManager.shared.getActiveTopic()
        TopicWrapper.addSubview(TopicTitle)
        ChatTableView.delegate = self
        ChatTableView.dataSource = self
        ChatTableView.register(IssueTableViewCell.self, forCellReuseIdentifier: "cell")
        NameInputField.delegate = self
        ChatInputField.delegate = self
        TopicTitle.text = topic?.title
        NotificationCenter.default.addObserver(self, selector: #selector(updateTopic), name: NSNotification.Name("UIUpdateNotification"), object: nil)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        DateText.text = dateFormatter.string(from: topic!.startTime)
        let arrangedView = [Title, TopicWrapper, DateText, NameInputField, ChatInputField, SendButton, ChatTableView]
        arrangedView.forEach{
            view.addSubview($0)
        }
        Title.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(14)
        }
        TopicWrapper.snp.makeConstraints{
            $0.top.equalTo(Title.snp.bottom).offset(12)
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
            $0.bottom.equalTo(NameInputField.snp.top).offset(-10)
            $0.width.equalTo(view.safeAreaLayoutGuide)
        }
        
        NameInputField.snp.makeConstraints{
            $0.bottom.equalTo(ChatInputField.snp.top).offset(-5)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(14)
        }
        
        SendButton.snp.makeConstraints{
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-14)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        ChatInputField.snp.makeConstraints{
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(14)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            $0.trailing.equalTo(SendButton.snp.leading).offset(-3)
        }
        
        observeMessages()
        SendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    // MARK: 여기에 채팅 연결하기
    @objc private func sendMessage() {
        topic = TopicManager.shared.getActiveTopic()
        guard let text = ChatInputField.text, !text.isEmpty else { return }
        guard let sender = NameInputField.text, !sender.isEmpty else {return}
        let messageId = databaseRef.child("chatRooms/\(topic?.title)/messages").childByAutoId().key!
        let messageData: [String: Any] = [
                "senderId": "\(sender)",
                "text": text,
                "timestamp": Date().timeIntervalSince1970
            ]
        databaseRef.child("chatRooms/\(topic?.title)/messages/\(messageId)").setValue(messageData) { [weak self] error, _ in
                guard let self = self else { return }
                if error == nil {
                    self.ChatTableView.reloadData()
                    self.scrollToBottom()
                } else {
                    print("Failed to send message: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
            ChatInputField.text = ""
    }
    
    private func observeMessages() {
        databaseRef.child("chatRooms/\(topic?.title)/messages").observe(.childAdded) { [weak self] snapshot in
                guard let self = self else { return }
                if let data = snapshot.value as? [String: Any],
                   let senderId = data["senderId"] as? String,
                   let text = data["text"] as? String,
                   let timestamp = data["timestamp"] as? TimeInterval {
                    let message = Message(id: snapshot.key, senderId: senderId, text: text, timestamp: timestamp)
                    self.messages.append(message)
                    self.ChatTableView.reloadData()
                    self.scrollToBottom()
                }
            }
        }
    
    private func scrollToBottom() {
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        ChatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
       }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IssueTableViewCell
        
        let message = messages[indexPath.row]
        cell.TitleLabel.text = message.senderId
        cell.ContentLabel.text = message.text
        cell.configure(isMyMessage: (message.senderId == NameInputField.text))
        return cell
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // 현재 텍스트
            let currentText = textField.text ?? ""

            // 변경 후 예상 텍스트
            guard let textRange = Range(range, in: currentText) else { return true }
            let updatedText = currentText.replacingCharacters(in: textRange, with: string)

            // 글자 수 제한
            if textField == NameInputField {
                return updatedText.count <= 6
            } else if textField == ChatInputField {
                return updatedText.count <= 40
            }

            return true
        }
    
    @objc private func updateTopic() {
        // 활성화된 토픽을 가져와 UI 업데이트
        topic = TopicManager.shared.getActiveTopic()
        TopicTitle.text = topic?.title
        observeMessages()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        DateText.text = dateFormatter.string(from: topic!.startTime)
        messages = topic?.messages ?? []
        ChatTableView.reloadData()
    }
    
    func getActiveTopicFromServer(){
        db.collection("chattopics").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                let chattopics = querySnapshot!.documents
                let data = chattopics[0].data()
                guard let title = data["title"] as? String,
                      let messages = data["messages"] as? [Message],
                      let vote = data["vote"] as? Int,
                      let activate = data["activate"] as? Bool,
                      let startTimeInterval = data["startTime"] as? TimeInterval else {
                          return
                      }
                print(startTimeInterval)
                let activeTopic = Topic(title: title, messages: messages, vote: vote, activate: activate, startTime: Date(timeIntervalSince1970: startTimeInterval))
                print(activeTopic)
                TopicManager.shared.setActiveTopic(activeTopic)
            }
        }
        
        
    }

    deinit {
        // 알림 옵저버 제거
        NotificationCenter.default.removeObserver(self)
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
