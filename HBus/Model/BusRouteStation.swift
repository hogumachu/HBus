import RxDataSources

struct BusRouteStation: IdentifiableType, Equatable {
    typealias Identity = String
    
    var identity: String
    let stationID: String // 정류소 아이디
    let stationSeq: String // 정류소 순번
    let stationName: String // 정류소명
    let regionName: String // 지역명
    let districtCd: String // 관할 지역
    let centerYn: String // 중앙차로 여부
    let turnYn: String // 회차 여부
}

enum BusRouteStationXMLElementName: String {
    case busRouteStationList = "busRouteStationList"
    case stationID = "stationId"
    case stationSeq = "stationSeq"
    case stationName = "stationName"
    case regionName = "regionName"
    case districtCd = "districtCd"
    case centerYn = "centerYn"
    case turnYn = "turnYn"
    case none = ""
}
