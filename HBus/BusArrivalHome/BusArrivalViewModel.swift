import UIKit.UITableViewCell
import RxSwift
import RxDataSources

typealias BusArrivalSectionModel = AnimatableSectionModel<String, BusArrivalName>

class BusArrivalViewModel {
    // MARK: - Dependency
    
    struct Dependency {
        let busRouteStaion: BusRouteStation
        let busRoutes: [BusRoute]
    }
    
    let busRouteStaion: BusRouteStation
    private var busRoutes: [BusRoute] = []
    
    // MARK: - Properties
    
    private var busArrivals: [BusArrivalName] = []
    private var notArrivals: [BusArrivalName] = []
    var busArrivalList = BehaviorSubject<[BusArrivalSectionModel]>(value: [])
    lazy var dataSource: RxTableViewSectionedAnimatedDataSource<BusArrivalSectionModel> = {
        let ds = RxTableViewSectionedAnimatedDataSource<BusArrivalSectionModel> { [weak self] dataSource, tableView, indexPath, item -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: BusArrivalTableViewCell.identifier, for: indexPath) as? BusArrivalTableViewCell ?? BusArrivalTableViewCell()
            
            cell.setItem(item: item)
            return cell
        }
        
        ds.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].model
        }
        
        return ds
    }()
    
    // MARK: - Initialize
    
    init(dependency: Dependency) {
        self.busRouteStaion = dependency.busRouteStaion
        self.busRoutes = dependency.busRoutes
    }
    
    // MARK: - Methods
    
    func getBusArrival() {
        BusArrivalAPI.shared.getBusArrivalList(stationID: busRouteStaion.stationID) { [weak self] result in
            switch result {
            case .success(let busArrivalArr):
                self?.busArrivals = busArrivalArr
                    .map { busArrival in
                        var busArrivalName = BusArrivalName(busArrival: busArrival, routeName: "-")
                        if let routeName = self?.busRoutes.first(where: { $0.routeID == busArrival.routeID })?.routeName, routeName != "-" {
                            busArrivalName.routeName = routeName
                        } else {
                            self?.getBusRoute(item: busArrival, completion: { busRoute in
                                busArrivalName.routeName = busRoute?.routeName ?? "-"
                            })
                        }
                        return busArrivalName
                    }
                    .sorted(by: { $0.routeName < $1.routeName })
                
                self?.notArrivals = self?.busRoutes
                    .filter  { busRoute in
                        return !busArrivalArr.contains(where: { $0.routeID == busRoute.routeID })
                    }
                    .compactMap { busRoute -> BusArrivalName in
                        var empty = BusArrival.empty
                        empty.routeID = busRoute.routeID
                        return BusArrivalName(busArrival: empty, routeName: self?.busRoutes.first(where: { $0.routeID == empty.routeID })?.routeName ?? "-")
                    } ?? []
                    .sorted(by: { $0.routeName < $1.routeName })
                
                if let notArriveBusArr = self?.notArrivals, !notArriveBusArr.isEmpty {
                    self?.busArrivalList.onNext([BusArrivalSectionModel(model: "운행중", items: self?.busArrivals ?? []), BusArrivalSectionModel(model: "대기중", items: notArriveBusArr)])
                } else {
                    self?.busArrivalList.onNext([BusArrivalSectionModel(model: "운행중", items: self?.busArrivals ?? [])])
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getBusRoute(item: BusArrival, completion: @escaping (BusRoute?) -> ()) {
        BusRouteAPI.shared.getBusRouteInfoItem(routeID: item.routeID) { result in
            switch result {
            case.success(let busRouteList):
                completion(busRouteList.first)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}
