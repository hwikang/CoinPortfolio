//
//  CoinListCoreData.swift
//  Portfolio
//
//  Created by paytalab on 7/26/24.
//

import Foundation
import CoreData

final public class CoinListCoreData {
    private let viewContext: NSManagedObjectContext
    
    public init(viewContext: NSManagedObjectContext = CoreDataManager.shared.viewContext) {
        self.viewContext = viewContext
    }
    
    public func saveFavorite(item: CoinListItem) -> Result<Bool, CoreDataError> {
        guard let entity = NSEntityDescription.entity(forEntityName: "FavoriteCoinListItem", in: viewContext) else {
            return .failure(CoreDataError.entityNotFound("FavoriteCoinListItem"))}
        
        do {
            let duplicatedLocation = try getFavoriteCoin(symbol: item.symbol)
            if duplicatedLocation != nil { return .failure(.saveError("Duplicated Location Info"))}
            let userObject = NSManagedObject(entity: entity, insertInto: viewContext)
            userObject.setValue(item.symbol, forKey: "symbol")
            userObject.setValue(item.close, forKey: "close")
            userObject.setValue(item.priceChange, forKey: "priceChange")
            userObject.setValue(item.priceChangePercent, forKey: "priceChangePercent")
            userObject.setValue(item.quoteVolume, forKey: "quoteVolume")
            try viewContext.save()
            return .success(true)
        } catch let error {
            return .failure(CoreDataError.saveError(error.localizedDescription))
        }
    }
    
    public func getFavotiteList() -> Result<[CoinListItem], CoreDataError>  {
        let fetchRequest: NSFetchRequest<FavoriteCoinListItem> = FavoriteCoinListItem.fetchRequest()
        do {
            let result = try viewContext.fetch(fetchRequest)
            let list: [CoinListItem] = result.compactMap { location in
               
                guard let symbol = location.symbol else { return nil }
                return CoinListItem(symbol: symbol, close: location.close, priceChangePercent: location.priceChangePercent, priceChange: location.priceChange,
                                    quoteVolume: location.quoteVolume)
            }
            return .success(list)
        } catch let error {
            return .failure(CoreDataError.readError(error.localizedDescription))
        }
    }
    
    public func deleteFavoriteUser(symbol: String) -> Result<Bool, CoreDataError> {
        let fetchRequest: NSFetchRequest<FavoriteCoinListItem> = FavoriteCoinListItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "symbol == %@", symbol)
        do {
            let favoriteUsers = try viewContext.fetch(fetchRequest)
            favoriteUsers.forEach {  viewContext.delete($0) }
            try viewContext.save()
            return .success(true)
        } catch let error {
            return .failure(CoreDataError.deleteError(error.localizedDescription))
        }
    }
    
    public func resetFavoriteList() -> Result<Bool, CoreDataError> {
        let fetchRequest: NSFetchRequest<FavoriteCoinListItem> = FavoriteCoinListItem.fetchRequest()
        do {
            let favoriteUsers = try viewContext.fetch(fetchRequest)
            favoriteUsers.forEach { viewContext.delete($0) }
            try viewContext.save()
            return .success(true)
        } catch let error {
            return .failure(CoreDataError.deleteError(error.localizedDescription))
        }

    }

    
    private func getFavoriteCoin(symbol: String) throws -> FavoriteCoinListItem? {
        let fetchRequest: NSFetchRequest<FavoriteCoinListItem> = FavoriteCoinListItem.fetchRequest()
        let predicate = NSPredicate(format: "symbol == %@", symbol)
        fetchRequest.predicate = predicate
        let results = try viewContext.fetch(fetchRequest)
        return results.first
    }
    
}
