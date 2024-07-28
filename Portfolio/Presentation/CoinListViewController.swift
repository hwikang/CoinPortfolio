//
//  ViewController.swift
//  Portfolio
//
//  Created by paytalab on 7/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class CoinListViewController: UIViewController {
    private let viewModel: CoinListViewModelProtocol
    private let saveFavorite = PublishRelay<CoinListItem>()
    private let deleteFavorite = PublishRelay<String>()
    
    public let textfield = SearchTextField()
    private let tabButtonView = TabButtonView(typeList: [.market, .favorite])
    private let sortButtonView = SortButtonView(sortList: [.name(nil), .price(nil), .change(nil), .quoteVolume(nil)])
    private let disposeBag = DisposeBag()
    private let coinListTableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        tableView.keyboardDismissMode = .onDrag
        tableView.register(CoinListItemCell.self,
                           forCellReuseIdentifier: CoinListItemCell.id)
        
        return tableView
    }()
    private let resetFavoriteListButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("즐겨찾기 일괄 해제", for: .normal)
        return button
    }()
    public init(viewModel: CoinListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
        bindView()
    }
    
    private func setUI() {
        view.addSubview(textfield)
        view.addSubview(tabButtonView)
        view.addSubview(sortButtonView)
        view.addSubview(coinListTableView)
        view.addSubview(resetFavoriteListButton)
        textfield.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(14)
            make.height.equalTo(44)
        }
        tabButtonView.snp.makeConstraints { make in
            make.top.equalTo(textfield.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(14)
            make.height.equalTo(60)
        }
        sortButtonView.snp.makeConstraints { make in
            make.top.equalTo(tabButtonView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(14)
            make.height.equalTo(44)
        }
        coinListTableView.snp.makeConstraints { make in
            make.top.equalTo(sortButtonView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        resetFavoriteListButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: .init(
            searchQuery: textfield.rx.text.orEmpty.distinctUntilChanged().debounce(.milliseconds(200), scheduler: MainScheduler.instance),
            tabButtonType: tabButtonView.selectedType.asObservable(),
            saveCoin: saveFavorite.asObservable(), 
            deleceCoin: deleteFavorite.asObservable(),
            sort: sortButtonView.selectedType.asObservable(),
            resetFavorite: resetFavoriteListButton.rx.tap.asObservable()
        ))
        
        output.cellData.observe(on: MainScheduler.instance)
            .bind(to: coinListTableView.rx.items) { [weak self] tableView, _, element in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinListItemCell.id) as? CoinListItemCell else { return UITableViewCell() }
                cell.apply(cellData: element)
                cell.favoriteButton.rx.tap.bind {
                    if element.isSelected {
                        self?.deleteFavorite.accept(element.data.symbol)
                    } else {
                        self?.saveFavorite.accept(element.data)
                    }

                }.disposed(by: cell.disposeBag)
                return cell
            }.disposed(by: disposeBag)
        output.error.bind { error in
            print(error)
        }.disposed(by: disposeBag)
        output.toastMessage.bind { [weak self] message in
            self?.showToast(message: message, duration: 5)
        }.disposed(by: disposeBag)
    }
    
    private func bindView() {
        tabButtonView.selectedType.bind { [weak self] type in
            if case type = .favorite {
                self?.resetFavoriteListButton.isHidden = false
            } else {
                self?.resetFavoriteListButton.isHidden = true

            }
        }.disposed(by: disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

