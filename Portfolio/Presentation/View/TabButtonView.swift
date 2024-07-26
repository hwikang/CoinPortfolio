//
//  TabButtonView.swift
//  Portfolio
//
//  Created by paytalab on 7/27/24.
//

import UIKit
import RxSwift
import RxCocoa
public enum TabButtonType: String {
    case market = "마켓"
    case favorite = "즐겨찾기"
}

final public class TabButtonView: UIStackView {

    private let disposeBag = DisposeBag()
    public let selectedType = BehaviorRelay<TabButtonType>(value: .market)

    private let dividerView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    
    public init(typeList: [TabButtonType]) {
        super.init(frame: .zero)
        axis = .horizontal
        alignment = .fill
        distribution = .fillEqually
        addButtons(typeList: typeList)
        addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
        bindView()
    }
    
    private func addButtons(typeList: [TabButtonType]) {
        typeList.forEach { type in
            let tabButton = TabButton(type: type)
            addArrangedSubview(tabButton)
            tabButton.rx.tap.bind { [weak self] in
                guard let self = self, !tabButton.isSelected else { return }
                selectedType.accept(type)
            }.disposed(by: disposeBag)
        }
    }
    
    private func bindView() {
        selectedType.bind { [weak self] type in
            self?.arrangedSubviews.compactMap { $0 as? TabButton }.forEach { $0.isSelected = $0.type == type ? true : false }
        }.disposed(by: disposeBag)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

final fileprivate class TabButton: UIButton {
    public let type: TabButtonType
    override var isSelected: Bool {
        didSet {
            if isSelected {
                titleLabel?.font = .systemFont(ofSize: 14, weight: .heavy)
            } else {
                titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
            }
        }
    }
    init(type: TabButtonType) {
        self.type = type
        super.init(frame: .zero)
        setTitle(type.rawValue, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        setTitleColor(.black, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
