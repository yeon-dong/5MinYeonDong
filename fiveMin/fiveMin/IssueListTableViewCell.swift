//
//  IssueListTableViewCell.swift
//  fiveMin
//
//  Created by jsj on 12/20/24.
//

import UIKit
import SnapKit
import Then

class IssueListTableViewCell: UITableViewCell {

    let TitleLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.numberOfLines = 1
        $0.lineBreakMode = .byTruncatingTail
        $0.adjustsFontSizeToFitWidth = false
    }
    
    private let TitleWrapper = UIView().then{
        $0.backgroundColor = UIColor.systemGray5
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        TitleWrapper.addSubview(TitleLabel)
        contentView.addSubview(TitleWrapper)
        TitleWrapper.snp.makeConstraints{
            $0.top.equalTo(contentView.snp.top)
            $0.leading.equalTo(contentView.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing)
            $0.height.equalTo(54)
        }
        TitleLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(TitleWrapper.snp.leading).offset(16)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
