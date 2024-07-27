//
//  ToastView.swift
//  Portfolio
//
//  Created by paytalab on 7/27/24.
//

import UIKit
import SnapKit

class ToastView: UIView {
    
    private var messageLabel = UILabel()
    
    init(message: String) {
        super.init(frame: .zero)
        setupView(message: message)
    }
    private func setupView(message: String) {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        

        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.numberOfLines = 0
        
        self.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
