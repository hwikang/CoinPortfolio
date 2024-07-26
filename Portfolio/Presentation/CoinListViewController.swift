//
//  ViewController.swift
//  Portfolio
//
//  Created by paytalab on 7/26/24.
//

import UIKit
import RxSwift
import SnapKit

class CoinListViewController: UIViewController {
    private let viewModel: CoinListViewModelProtocol
    public let textfield = SearchTextField()
    private let disposeBag = DisposeBag()

    public init(viewModel: CoinListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
    }
    
    private func setUI() {
        view.addSubview(textfield)
        textfield.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(14)
            make.height.equalTo(44)
        }
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: .init(searchQuery: textfield.rx.text.orEmpty.distinctUntilChanged()))
        output.coinList.bind { coinList in
            print(coinList)
        }.disposed(by: disposeBag)
        output.error.bind { error in
            print(error)
        }.disposed(by: disposeBag)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

