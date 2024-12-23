//
//  IssueTableViewCell.swift
//  fiveMin
//
//  Created by jsj on 12/19/24.
//

import UIKit
import SnapKit
import Then

class IssueTableViewCell: UITableViewCell {

    let TitleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.numberOfLines = 2
        $0.lineBreakMode = .byTruncatingTail
        $0.adjustsFontSizeToFitWidth = false
    }
    
    let ContentLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    
    private let containerView = UIView().then {
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .systemGray5
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(containerView)
        containerView.addSubview(TitleLabel)
        containerView.addSubview(ContentLabel)
        
        // 기본 왼쪽 정렬 제약 조건
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10).priority(.medium)
            $0.width.lessThanOrEqualToSuperview().multipliedBy(0.7) // 최대 70% 너비
        }
        
        TitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
        }
        
        ContentLabel.snp.makeConstraints {
            $0.top.equalTo(TitleLabel.snp.bottom).offset(4)
            $0.leading.equalToSuperview().offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview().offset(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 메시지가 "나"인지에 따라 레이아웃을 변경
    func configure(isMyMessage: Bool) {
        if isMyMessage {
            // 내 메시지 (오른쪽 정렬)
            containerView.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview().inset(10)
                $0.trailing.equalToSuperview().offset(-10)
                $0.leading.greaterThanOrEqualToSuperview().offset(50)
            }
            
            containerView.backgroundColor = .systemBlue
            TitleLabel.textAlignment = .right
            ContentLabel.textAlignment = .right
            ContentLabel.textColor = .white
            TitleLabel.textColor = .white
        } else {
            // 다른 사람 메시지 (왼쪽 정렬)
            containerView.snp.remakeConstraints {
                $0.top.bottom.equalToSuperview().inset(10)
                $0.leading.equalToSuperview().offset(10)
                $0.trailing.lessThanOrEqualToSuperview().offset(-50)
            }
            
            containerView.backgroundColor = .systemGray5
            TitleLabel.textAlignment = .left
            ContentLabel.textAlignment = .left
            ContentLabel.textColor = .black
            TitleLabel.textColor = .black
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
