import RxDataSources

struct BusLocation {
    let routeID: String // 노선 아이디
    let stationID: String // 정류소 아이디
    let stationSeq: String // 정류소 순번
    let endBus: String // 막차 여부 (0: 일반, 1: 막차)
    let lowPlate: String // 저상버스 여부 (0: 일반, 1: 저상버스)
    let plateNo: String // 차량번호
    let plateType: String // 차종 (0: 정보 없음, 1: 소형승합차, 2: 중형승합차, 3: 대형승합차)
    let remainSeatCnt: String // 차량 빈자리 수 (-1: 정보 없음, 0~n: 빈자리 수)
}

enum BusLocationXMLElementName: String {
    case busLocationList = "busLocationList"
    case routeID = "routeId"
    case stationID = "stationId"
    case stationSeq = "stationSeq"
    case endBus = "endBus"
    case lowPlate = "lowPlate"
    case plateNo = "plateNo"
    case plateType = "plateType"
    case remainSeatCnt = "remainSeatCnt"
    case none = ""
}
