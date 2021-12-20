import RxDataSources

struct BusArrivalName: IdentifiableType, Equatable  {
    var identity: String {
        return busArrival.routeID
    }
    
    typealias Identity = String
    
    var busArrival: BusArrival
    var routeName: String
}
