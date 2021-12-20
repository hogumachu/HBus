import Foundation
import RxDataSources

struct BusArrival: IdentifiableType, Equatable  {
    var identity: String
    
    typealias Identity = String
    
    let stationID: String // 정류소 아이디
    var routeID: String // 노선 아이디
    let locationNo1: String // 첫번째 차량 위치 정보
    let predictTime1: String // 첫번째 차량 도착 예상 시간
    let lowPlate1: String // 첫번째차량 저상버스 여부
    let plateNo1: String // 첫번째차량 차량 번호
    let remainSeatCnt1: String // 첫번째차량 빈자리 수
    let locationNo2: String // 첫번째 차량 위치 정보
    let predictTime2: String // 첫번째 차량 도착 예상 시간
    let lowPlate2: String // 두번째차량 저상버스 여부
    let plateNo2: String // 두번째차량 차량 번호
    let remainSeatCnt2: String // 두번째차량 빈자리 수
    let staOrder: String // 정류소 순번
    let flag: String // 상태 구분 (RUN: 운행중, PASS: 운행중, STOP: 운행종료, WAIT: 회차지대기)
    
    
}

extension BusArrival {
    static let empty = BusArrival(
        identity: "\(Date().timeIntervalSinceReferenceDate)",
        stationID: "",
        routeID: "",
        locationNo1: "",
        predictTime1: "",
        lowPlate1: "",
        plateNo1: "",
        remainSeatCnt1: "",
        locationNo2: "",
        predictTime2: "",
        lowPlate2: "",
        plateNo2: "",
        remainSeatCnt2: "",
        staOrder: "",
        flag: ""
    )
}

enum BusArrivalXMLElementName: String {
    case busArrivalList = "busArrivalList"
    case flag = "flag"
    case locationNo1 = "locationNo1"
    case locationNo2 = "locationNo2"
    case lowPlate1 = "lowPlate1"
    case lowPlate2 = "lowPlate2"
    case plateNo1 = "plateNo1"
    case plateNo2 = "plateNo2"
    case predictTime1 = "predictTime1"
    case predictTime2 = "predictTime2"
    case remainSeatCnt1 = "remainSeatCnt1"
    case remainSeatCnt2 = "remainSeatCnt2"
    case routeId = "routeId"
    case staOrder = "staOrder"
    case stationId = "stationId"
    case none = ""
}
