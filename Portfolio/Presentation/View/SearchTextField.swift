//
//  SearchTextField.swift
//  Portfolio
//
//  Created by paytalab on 7/27/24.
//

import UIKit
import RxSwift

final public class SearchTextField: UITextField {
    private let disposeBag = DisposeBag()
    let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    let clearButton = UIButton(type: .system)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        bindView()
    }
    
    private func setUI() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 5
        imageView.tintColor = .black
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        leftView = imageView
        leftViewMode = .always
        clearButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        clearButton.tintColor = .black
        clearButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        rightView = clearButton
        rightViewMode = .always
        textColor = .black
        placeholder = "검색어를 입력해 주세요"
    }
    private func bindView() {
         rx.text.map({ $0?.isEmpty != false })
             .bind(to: clearButton.rx.isHidden)
             .disposed(by: disposeBag)
         
         clearButton.rx.tap.bind { [weak self] in
             self?.text = nil
             self?.sendActions(for: .valueChanged)
         }.disposed(by: disposeBag)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
