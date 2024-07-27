//
//  CoinListViewModel.swift
//  Portfolio
//
//  Created by paytalab on 7/27/24.
//
import Foundation
import RxSwift
import RxCocoa

public protocol CoinListViewModelProtocol {
    func transform(input: CoinListViewModel.Input) -> CoinListViewModel.Output
}

public struct CoinListViewModel: CoinListViewModelProtocol {
    private let usecase: CoinListUsecaseProtocol
    private let disposeBag = DisposeBag()
    private let error = PublishRelay<String>()
    private let coinList = PublishRelay<[CoinListItem]>()

    init(usecase: CoinListUsecaseProtocol) {
        self.usecase = usecase
    }
    
    public struct Input {
        let searchQuery: Observable<String>
        
    }
    
    public struct Output {
        let coinList: Observable<[CoinListItem]>
        let error: Observable<String>
    }
    
    public func transform(input: Input) -> Output {
        input.searchQuery.bind { query in
            fetchList(query: query)
        }.disposed(by: disposeBag)
        
        return Output(coinList: coinList.asObservable(), error: error.asObservable())
    }
    
    private func fetchList(query: String) {
        Task {
            let result = await usecase.fetchList(query: query)
            switch result {
            case let .success(coinList):
                self.coinList.accept(coinList)
            case let .failure(error):
                self.error.accept(error.description)
                
            }
        }
    }
}
