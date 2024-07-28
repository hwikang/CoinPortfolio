//
//  CoinListViewModelTests.swift
//  PortfolioTests
//
//  Created by paytalab on 7/28/24.
//

import XCTest
@testable import Portfolio

final class CoinListViewModelTests: XCTestCase {
    var viewModel: CoinListViewModel!
    var mockUsecase: MockCoinListUsecase!
    
    
    override func setUp() {
        super.setUp()
        mockUsecase = MockCoinListUsecase()
        viewModel = CoinListViewModel(usecase: mockUsecase)
    }
    
    override func tearDown() {
        viewModel = nil
        mockUsecase = nil
        super.tearDown()
    }
    
    func testSortedByNameAscending() {
        // Given
        let coinList = [
            CoinListItem(symbol: "BTC", close: 45000.0, priceChangePercent: 5.0, priceChange: 2000.0, quoteVolume: 10000.0),
            CoinListItem(symbol: "ETH", close: 3000.0, priceChangePercent: 3.0, priceChange: 100.0, quoteVolume: 5000.0),
            CoinListItem(symbol: "ADA", close: 1.2, priceChangePercent: 2.0, priceChange: 0.05, quoteVolume: 1500.0)
        ]
        
        // When
        let sortedList = viewModel.sorted(coinList: coinList, sort: .name(.ascending))
        
        // Then
        XCTAssertEqual(sortedList.map { $0.symbol }, ["ADA", "BTC", "ETH"])
    }
    
    func testSortedByNameDescending() {
        // Given
        let coinList = [
            CoinListItem(symbol: "BTC", close: 45000.0, priceChangePercent: 5.0, priceChange: 2000.0, quoteVolume: 10000.0),
            CoinListItem(symbol: "ETH", close: 3000.0, priceChangePercent: 3.0, priceChange: 100.0, quoteVolume: 5000.0),
            CoinListItem(symbol: "ADA", close: 1.2, priceChangePercent: 2.0, priceChange: 0.05, quoteVolume: 1500.0)
        ]
        
        // When
        let sortedList = viewModel.sorted(coinList: coinList, sort: .name(.descending))
        
        // Then
        XCTAssertEqual(sortedList.map { $0.symbol }, ["ETH", "BTC", "ADA"])
    }
    
    func testSortedByPriceAscending() {
        // Given
        let coinList = [
            CoinListItem(symbol: "BTC", close: 45000.0, priceChangePercent: 5.0, priceChange: 2000.0, quoteVolume: 10000.0),
            CoinListItem(symbol: "ETH", close: 3000.0, priceChangePercent: 3.0, priceChange: 100.0, quoteVolume: 5000.0),
            CoinListItem(symbol: "ADA", close: 1.2, priceChangePercent: 2.0, priceChange: 0.05, quoteVolume: 1500.0)
        ]
        
        // When
        let sortedList = viewModel.sorted(coinList: coinList, sort: .price(.ascending))
        
        // Then
        XCTAssertEqual(sortedList.map { $0.close }, [1.2, 3000.0, 45000.0])
    }
    
    func testSortedByPriceDescending() {
        // Given
        let coinList = [
            CoinListItem(symbol: "BTC", close: 45000.0, priceChangePercent: 5.0, priceChange: 2000.0, quoteVolume: 10000.0),
            CoinListItem(symbol: "ETH", close: 3000.0, priceChangePercent: 3.0, priceChange: 100.0, quoteVolume: 5000.0),
            CoinListItem(symbol: "ADA", close: 1.2, priceChangePercent: 2.0, priceChange: 0.05, quoteVolume: 1500.0)
        ]
        
        // When
        let sortedList = viewModel.sorted(coinList: coinList, sort: .price(.descending))
        
        // Then
        XCTAssertEqual(sortedList.map { $0.close }, [45000.0, 3000.0, 1.2])
    }
    func testCreateCellDataForMarketTab() {
        // Given
        let coinList = [
            CoinListItem(symbol: "BTC", close: 45000.0, priceChangePercent: 5.0, priceChange: 2000.0, quoteVolume: 10000.0),
            CoinListItem(symbol: "ETH", close: 3000.0, priceChangePercent: 3.0, priceChange: 100.0, quoteVolume: 5000.0),
            CoinListItem(symbol: "ADA", close: 1.2, priceChangePercent: 2.0, priceChange: 0.05, quoteVolume: 1500.0)
        ]
        
        let favoriteCoinList = [
            CoinListItem(symbol: "BTC", close: 45000.0, priceChangePercent: 5.0, priceChange: 2000.0, quoteVolume: 10000.0)
        ]
        
        let allFavoriteCoinList = favoriteCoinList
        let sortType = SortType.name(.ascending)
        
        // When
        let cellData = viewModel.createCellData(coinList: coinList, allFavoriteCoinList: allFavoriteCoinList, favoriteCoinList: favoriteCoinList, tabType: .market, sort: sortType)
        
        // Then
        XCTAssertEqual(cellData.count, 3)
        XCTAssertEqual(cellData[0].data.symbol, "ADA")
        XCTAssertEqual(cellData[0].isSelected, false)
        XCTAssertEqual(cellData[1].data.symbol, "BTC")
        XCTAssertEqual(cellData[1].isSelected, true)
        XCTAssertEqual(cellData[2].data.symbol, "ETH")
        XCTAssertEqual(cellData[2].isSelected, false)
    }
    
    func testCreateCellDataForFavoriteTab() {
        // Given
        let coinList = [
            CoinListItem(symbol: "BTC", close: 45000.0, priceChangePercent: 5.0, priceChange: 2000.0, quoteVolume: 10000.0),
            CoinListItem(symbol: "ETH", close: 3000.0, priceChangePercent: 3.0, priceChange: 100.0, quoteVolume: 5000.0),
            CoinListItem(symbol: "ADA", close: 1.2, priceChangePercent: 2.0, priceChange: 0.05, quoteVolume: 1500.0)
        ]
        
        let favoriteCoinList = [
            CoinListItem(symbol: "BTC", close: 45000.0, priceChangePercent: 5.0, priceChange: 2000.0, quoteVolume: 10000.0),
            CoinListItem(symbol: "ETH", close: 3000.0, priceChangePercent: 3.0, priceChange: 100.0, quoteVolume: 5000.0)
        ]
        
        let allFavoriteCoinList = favoriteCoinList
        let sortType = SortType.name(.ascending)
        
        // When
        let cellData = viewModel.createCellData(coinList: coinList, allFavoriteCoinList: allFavoriteCoinList, favoriteCoinList: favoriteCoinList, tabType: .favorite, sort: sortType)
        
        // Then
        XCTAssertEqual(cellData.count, 2)
        XCTAssertEqual(cellData[0].data.symbol, "BTC")
        XCTAssertEqual(cellData[0].isSelected, true)
        XCTAssertEqual(cellData[1].data.symbol, "ETH")
        XCTAssertEqual(cellData[1].isSelected, true)
    }
}
