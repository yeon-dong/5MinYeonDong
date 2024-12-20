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

    let TitleLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    let ContentLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(TitleLabel)
        contentView.addSubview(ContentLabel)
        TitleLabel.snp.makeConstraints{
            $0.top.equalTo(contentView.snp.top).offset(5)
            $0.height.equalTo(20)
            $0.leading.equalTo(contentView.snp.leading).offset(14)
        }
        ContentLabel.snp.makeConstraints{
            $0.top.equalTo(TitleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(contentView.snp.leading).offset(14)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
