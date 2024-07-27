//
//  SortButtonView.swift
//  Portfolio
//
//  Created by paytalab on 7/27/24.
//

import UIKit
import RxSwift
import RxCocoa

extension SortType {
    var title: String {
        switch self {
        case .name: "가상자산명"
        case .price: "현재가"
        case .change: "24시간"
        case .quoteVolume: "거래대금"
        }
    }
}
final public class SortButtonView: UIStackView {

    private let disposeBag = DisposeBag()
    public let selectedType = BehaviorRelay<SortType>(value: .quoteVolume(.descending))
    
    private let dividerView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()

    
    public init(sortList: [SortType]) {
        super.init(frame: .zero)
        axis = .horizontal
        alignment = .fill
        distribution = .fillProportionally
        addButtons(sortList: sortList)
        addSubview(dividerView)
        dividerView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
        bindView()
    }
    
    
    private func addButtons(sortList: [SortType]) {
        sortList.forEach { sort in
            let button = SortButton(type: sort)
            addArrangedSubview(button)
            button.tapButton?.bind { [weak self] order in
                let nextOrder = self?.nextOrder(order: order)
                switch sort {
                case .name: self?.selectedType.accept(.name(nextOrder))
                case .price: self?.selectedType.accept(.price(nextOrder))
                case .change: self?.selectedType.accept(.change(nextOrder))
                case .quoteVolume: self?.selectedType.accept(.quoteVolume(nextOrder))
                }
                
            }.disposed(by: disposeBag)
        }
    }
    
    private func bindView() {
        
        selectedType.bind { [weak self] type in

            self?.arrangedSubviews.compactMap { $0 as? SortButton }.forEach { sortButton in
                if sortButton.type == type {
                    sortButton.type = type
                } else {
                    switch sortButton.type {
                    case .name: sortButton.type = .name(nil)
                    case .price: sortButton.type = .price(nil)
                    case .change: sortButton.type = .change(nil)
                    case .quoteVolume: sortButton.type = .quoteVolume(nil)
                    }
                }
               
            }
                
        }.disposed(by: disposeBag)
    }
    
    private func nextOrder(order: Order?) -> Order? {
        switch order {
        case .descending: return .ascending
        case .ascending: return .descending
        default: return .descending
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

final fileprivate class SortButton: UIButton {
    public var tapButton: Observable<Order?>?
    public var type: SortType {
        didSet {

            switch type {
            case let .name(order), let .price(order), let .change(order), let .quoteVolume(order):
                if order == .ascending || order == .descending {
                    titleLabel?.font = .systemFont(ofSize: 14, weight: .heavy)
                    setImage(order == .ascending ? UIImage(systemName: "arrow.down") : UIImage(systemName: "arrow.up"),
                             for: .normal)
                    
                } else {
                    titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
                    setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)

                }
            }
        }
    }
    
    init(type: SortType) {
        self.type = type
        super.init(frame: .zero)
        setTitle(type.title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        setTitleColor(.black, for: .normal)
        setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        semanticContentAttribute = .forceRightToLeft
        tapButton = rx.tap.map { [weak self] in
            guard let self = self else { return nil }
            switch self.type {
            case let .name(order), let .price(order), let .change(order), let .quoteVolume(order): return order
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
