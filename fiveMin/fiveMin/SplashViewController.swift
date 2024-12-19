//
//  SplashViewController.swift
//  fiveMin
//
//  Created by jsj on 12/19/24.
//
import Then
import UIKit

class SplashViewController: UIViewController {
    

    private let titleLabel = UILabel().then {
        let attributedString = NSMutableAttributedString()

        // "5" 부분
        let numberAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 46), // "5"의 폰트 크기
            .foregroundColor: UIColor(red: 70/255, green: 130/255, blue: 180/255, alpha: 1) // 진한 파란색
        ]
        let numberString = NSAttributedString(string: "5", attributes: numberAttributes)
        attributedString.append(numberString)

        // "분 연동" 부분
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 32), // 나머지 텍스트의 폰트 크기
            .foregroundColor: UIColor(red: 70/255, green: 130/255, blue: 180/255, alpha: 1) // 동일한 색상
        ]
        let textString = NSAttributedString(string: " 분 연동", attributes: textAttributes)
        attributedString.append(textString)

        $0.attributedText = attributedString
        $0.textAlignment = .center // 텍스트 가운데 정렬
    }
    
    private let imageView = UIImageView().then {
        $0.image = UIImage(named: "splash_img") // 에셋 폴더의 이미지 이름
        $0.contentMode = .scaleAspectFill // 이미지 비율 유지
        $0.clipsToBounds = true // 이미지가 잘리지 않도록 설정
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        // 5초 후에 Main 화면으로 전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.navigateToMain()
        }
    }
    
    private func setupViews() {
        view.backgroundColor = .white // 배경색 설정
        
        // titleLabel 추가
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // imageView 추가
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Auto Layout 설정
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6), // 화면 높이의 50%로 설정
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: imageView.topAnchor, constant: -80) // 이미지 바로 위에 위치
        ])
    }
    
    private func navigateToMain() {
        // MainViewController 인스턴스 생성
        let mainVC = MainViewController() // MainViewController를 초기화
        
        // 전환 애니메이션과 함께 화면 전환
        mainVC.modalTransitionStyle = .crossDissolve // 전환 스타일 설정
        mainVC.modalPresentationStyle = .fullScreen // 전체 화면으로 설정
        self.present(mainVC, animated: true, completion: nil) // MainViewController로 전환
    }
}
