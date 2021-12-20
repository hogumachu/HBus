import UIKit.UITableViewCell
import RxSwift
import RxDataSources

typealias BusRouteStationSectionModel = AnimatableSectionModel<Int, BusRouteStation>

class BusRouteStationViewModel {
    struct Dependency {
        let busRoute: BusRoute
    }
    
    let busRoute: BusRoute
    
    private var busRouteStations: [BusRouteStation] = []
    var busLocations = BehaviorSubject<[BusLocation]>(value: [])
    private var busLocationDictionary: [String: BusLocation] = [:]
    var busRouteStationList = BehaviorSubject<[BusRouteStationSectionModel]>(value: [])
    lazy var dataSource: RxTableViewSectionedAnimatedDataSource<BusRouteStationSectionModel> = {
        let ds = RxTableViewSectionedAnimatedDataSource<BusRouteStationSectionModel> { [weak self] dataSource, tableView, indexPath, item -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: BusRouteStationTableViewCell.identifier, for: indexPath) as? BusRouteStationTableViewCell ?? BusRouteStationTableViewCell()
            
            cell.setItem(item: item)
            
            if let location = self?.busLocationDictionary[item.stationSeq] {
                cell.setBus(true, count: location.remainSeatCnt)
            } else {
                cell.setBus(false)
            }
            
            return cell
        }
        return ds
    }()
    
    init(dependency: Dependency) {
        self.busRoute = dependency.busRoute
    }
    
    func searchBusStationList() {
        BusRouteAPI.shared.getBusRouteStationList(routeID: busRoute.routeID) { [weak self] result in
            switch result {
            case .success(let busStationArr):
                self?.busRouteStations = busStationArr
                self?.busRouteStationList.onNext([BusRouteStationSectionModel(model: 0, items: busStationArr)])
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loadBusLocationList() {
        BusRouteAPI.shared.getBusLocationList(routeID: busRoute.routeID) { [weak self] result in
            switch result {
            case .success(let busLocationArr):
                self?.busLocations.onNext(busLocationArr.sorted(by: { $0.stationSeq < $1.stationSeq } ))
                self?.busLocationDictionary = [:]
                busLocationArr.forEach {
                    self?.busLocationDictionary["\(Int($0.stationSeq)! + 1)"] = $0
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getBusStationViaRoute(stationID: String, completion: @escaping ([BusRoute]?) -> ()) {
        BusRouteAPI.shared.getBusStationViaRouteList(stationID: stationID) { result in
            switch result {
            case .success(let busRoutes):
                completion(busRoutes)
            case .failure(_):
                completion(nil)
            }
        }
    }
}
