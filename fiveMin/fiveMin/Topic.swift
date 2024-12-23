//
//  Topic.swift
//  fiveMin
//
//  Created by jsj on 12/20/24.
//

import Foundation

struct Topic: Codable {
    var title: String
    var messages: [Message]
    var vote: Int
    var activate: Bool
    var startTime: Date
    
    // Firestore에 저장할 수 있도록 딕셔너리로 변환하는 메서드
    func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "messages": messages,
            "vote": vote,
            "activate": activate,
            "startTime": startTime
        ]
    }
}

class TopicManager {
    
    // 싱글톤 인스턴스
    static let shared = TopicManager()
    
    // 현재 활성화된 토픽
    private(set) var activeTopic: Topic? = nil
    private let defaultTopic = Topic(title: "기본 주제", messages: [], vote: 1, activate: false, startTime: Date())
    
    // private 초기화 (외부에서 인스턴스 생성 불가)
    private init() {}
    
    // 활성화된 토픽 설정
    func setActiveTopic(_ topic: Topic) {
        self.activeTopic = topic
    }
    
    // 활성화된 토픽을 가져오는 함수
    func getActiveTopic() -> Topic? {
        return activeTopic ?? defaultTopic
    }
    
}
