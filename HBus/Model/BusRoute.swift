import RxDataSources

struct BusRoute: IdentifiableType, Equatable {
    typealias Identity = String
    
    var identity: String
    let routeID: String // 노선 아이디
    let routeName: String // 노선 번호
    let routeTypeCd: String // 노선 유형 (11, 12, 13, 14, 15, 16, 21, 22, 23, 30, 41, 42, 43, 51, 52, 53)
    let routeTypeName: String // 노선 유형명
    let regionName: String // 지역명
    let districtCd: String // 관할 지역 (1: 서울, 2: 경기, 3: 인천)
}

enum BusRouteXMLElementName: String {
    case busRouteList = "busRouteList"
    case routeID = "routeId"
    case routeName = "routeName"
    case routeTypeCd = "routeTypeCd"
    case routeTypeName = "routeTypeName"
    case regionName = "regionName"
    case districtCd = "districtCd"
    case none = ""
}
