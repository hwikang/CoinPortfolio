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
    private let sortType = PublishRelay<SortType>()
    
    public let textfield = SearchTextField()
    private let tabButtonView = TabButtonView(typeList: [.market, .favorite])
    private let sortButtonView = SortButtonView(sortList: [.name(nil), .price(nil), .change(nil), .quoteVolume(nil)])
    private let disposeBag = DisposeBag()
    private let coinListTableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        tableView.register(CoinListItemCell.self,
                           forCellReuseIdentifier: CoinListItemCell.id)
        
        return tableView
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
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: .init(
            searchQuery: textfield.rx.text.orEmpty.distinctUntilChanged().debounce(.milliseconds(200), scheduler: MainScheduler.instance), tabButtonType: tabButtonView.selectedType.asObservable(),
            saveCoin: saveFavorite.asObservable(), deleceCoin: deleteFavorite.asObservable(), sort: sortType.asObservable()
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
       
        
        sortButtonView.selectedType.bind { sort in
            switch sort {
            case let .name(order):
                print("name\(order)")
            case let .price(order):
                print("price \(order)")
            case let .change(order):
                print("change \(order)")
            case let .quoteVolume(order):
                print("quoteVolume \(order)")
            default: print("null")
            }
        }.disposed(by: disposeBag)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

