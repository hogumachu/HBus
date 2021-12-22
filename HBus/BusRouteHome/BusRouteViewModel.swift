import UIKit.UITableViewCell
import RxSwift
import RxDataSources

typealias BusRouteSectionModel = AnimatableSectionModel<String, BusRoute>

class BusRouteViewModel {
    // MARK: - Properties
    
    private var busRoutes: [BusRoute] = []
    var busRouteList = BehaviorSubject<[BusRouteSectionModel]>(value: [])
    private var loading: Bool = false
    lazy var loadingObservable = BehaviorSubject<Bool>(value: loading)
    let dataSource: RxTableViewSectionedAnimatedDataSource<BusRouteSectionModel> = {
        let ds = RxTableViewSectionedAnimatedDataSource<BusRouteSectionModel> { dataSource, tableView, indexPath, item -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: BusRouteTableViewCell.identifier, for: indexPath) as? BusRouteTableViewCell ?? BusRouteTableViewCell()
            
            cell.setItem(item: item)
            return cell
        }
        return ds
    }()
    
    // MARK: - Methods
    
    func searchBusRoute(routeName: String) {
        if routeName.isEmpty || loading {
            return
        }
        
        loading = true
        loadingObservable.onNext(true)
        
        BusRouteAPI.shared.getBusRouteList(routeName: routeName) { [weak self] result in
            switch result {
            case .success(let busRouteArr):
                let sortedBusRoutes = busRouteArr.sorted(by: { $0.routeName < $1.routeName})
                self?.loading = false
                self?.loadingObservable.onNext(false)
                self?.busRoutes = sortedBusRoutes
                self?.busRouteList.onNext([BusRouteSectionModel(model: "경기", items: sortedBusRoutes)])
            case .failure(let error):
                self?.loading = false
                self?.loadingObservable.onNext(false)
                print(error.localizedDescription)
            }
        }
    }
    
    func item(at indexPath: IndexPath) -> BusRoute {
        return busRoutes[indexPath.row]
    }
}
