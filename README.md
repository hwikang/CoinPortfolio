# CoinPortfolio
### 

# 프로젝트 설명

## 라이브러리

사용 라이브러리 - RxSwift, Snapkit, Alamofire

RxSwift 를 통해 비동기적인 이벤트 스트림을 핸들링 하였습니다. 

Snapkit 을 활용하여 레이아웃 제약조건 코드를 간결화 하였습니다. 

Alamofire 를 활용하여 HTTP 네트워크 호출을 구현 하였습니다.

## 프로젝트 구성

Clean Architecture 구조의 MVVM 패턴을 활용 하여 프로젝트를 구성했습니다.

Presentation , Domain, Data 레이어로 구분되어있고

Presentation → Domin ← Data 단방향 의존성 관리되어있습니다.

### Domain

Usecase, RepositoryProtocol, Entity 로 구성됩니다.

Entity - 네트워크 응답을 객체화 하기위한 NetworkResponse, CoinListItem

에러 타입을 담은 NetworkError CoreDataError 

정렬 알고리즘에필요한 SortType 이 포함됩니다.

NetworkResponse 의 경우 일관적인 네트워크 응답에 대응하여 제너릭 data 타입을 사용하여 다른 네트워크 호출에도 사용될수 있습니다.

```jsx

public struct NetworkResponse<T: Decodable>: Decodable {
    let success: Bool
    let data: T?
}

```

Usecase - Repository 메소드를 호출하는 핵심 비즈니스 로직을 담당합니다.

저수준 모듈 Data 에 의존하지 않기 위해 RepositoryProtocol (추상화 인터페이스) 를 사용, 의존 하였습니다.

### Data

Network CoreData Repository 로 구성됩니다.

Network - http 네트워크 호출 담당 API 구현했으며 NetworkManager를 사용하여 중복되는 코드를 줄이고 여러 네트워크 호출에 활용됩니다. 

```jsx
 func fetchData<T:Decodable> (url: String, method: HTTPMethod, parameters: Parameters? = nil,
                                 encoding: ParameterEncoding = URLEncoding.default) async -> Result<T?, NetworkError>
```

CoreData - CoreData 내부데이터 에 접근, CRUD 작업을 담당합니다.

FavoriteCoinListItem 객체를 사용합니다.

Repository - Network, CoreData를 활용하여 원하는 데이터를 리턴해줍니다.

### Presentation

UI 부분을 담당하는 ViewController, ViewModel 이 있습니다.

MVVM 패턴으로 구성되었고 VM ←VC 간의 이벤트는 Input (VC→VM) Output(VM→VC) 로 정의되었습니다

```jsx
  
    public struct Input {
        let searchQuery: Observable<String>
        let tabButtonType: Observable<TabButtonType>
        let saveCoin: Observable<CoinListItem>
        let deleceCoin: Observable<String>
        let sort: Observable<SortType>
        let resetFavorite: Observable<Void>
    }
    
    public struct Output {
        let cellData: Observable<[CoinListItemCellData]>
        let error: Observable<String>
        let toastMessage: Observable<String>
    }
```

Output.cellData 를 통해 리스트에 쓰일 데이터가 전달됩니다. 탭의 상태, 정렬상태, 그리고 리스트를 활용하여 데이터 리스트를 구성합니다.

CoinListItemCellData 는 CoinListItem 객체와 즐겨찾기 선택상태를 담고있습니다.

```jsx

public struct CoinListItemCellData {
    let isSelected: Bool
    let data: CoinListItem
}

```

검색 기능 을 API 에서 지원하지 않아 내부 필터링으로 구현했습니다. 따라서 init과 함께 1회 네트워크, Coredata  fetch 이후 전체 리스트를 저장하여 query 필터링후 리스트를 제공합니다

```jsx
    private let coinList = PublishRelay<Set<CoinListItem>>()
    private let favoriteCoinList = PublishRelay<Set<CoinListItem>>()
    private let allCoinList = BehaviorRelay<Set<CoinListItem>>(value: [])
    private let allFavoriteCoinList = BehaviorRelay<Set<CoinListItem>>(value: [])

```

이후에 정렬 로직이 따로 실행되며 Filter의 성능을 개선 하기 위해 Array 대신 Set을 사용했습니다
