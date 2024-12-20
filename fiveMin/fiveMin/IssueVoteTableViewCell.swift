//
//  IssueVoteTableViewCell.swift
//  fiveMin
//
//  Created by jsj on 12/20/24.
//

import UIKit
import SnapKit
import Then

class IssueVoteTableViewCell: UITableViewCell {
    
    
    private let Wrapper = UIView().then{
        $0.backgroundColor = .systemGray5
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    let TitleLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    private let VoteImage = UIImageView().then{
        $0.image = UIImage.init(systemName: "hand.thumbsup.fill")
        $0.tintColor = .black
    }
    
    let VoteLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        Wrapper.addSubview(TitleLabel)
        Wrapper.addSubview(VoteLabel)
        Wrapper.addSubview(VoteImage)
        contentView.addSubview(Wrapper)
        Wrapper.snp.makeConstraints{
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.bottom.equalTo(VoteLabel.snp.bottom).offset(10)
        }
        TitleLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(Wrapper.snp.leading).offset(16)
        }
        VoteImage.snp.makeConstraints{
            $0.top.equalTo(TitleLabel.snp.bottom).offset(5)
            $0.trailing.equalTo(VoteLabel.snp.leading)
        }
        VoteLabel.snp.makeConstraints{
            $0.top.equalTo(TitleLabel.snp.bottom).offset(5)
            $0.trailing.equalTo(Wrapper.snp.trailing).offset(-16)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
