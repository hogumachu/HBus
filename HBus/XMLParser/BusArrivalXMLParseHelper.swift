import Foundation

class BusArrivalXMLParseHelper: NSObject, XMLParserDelegate {
    static let shared = BusArrivalXMLParseHelper()
    private override init() {}
    private var xmlDictionary: [String: String] = [:]
    private var xmlElementName = BusArrivalXMLElementName.none
    private var busArrivals: [BusArrival] = []
    
    func parse(_ url: URL, completion: @escaping (Result<[BusArrival], Error>) -> ()) {
        let xmlParser = XMLParser(contentsOf: url)
        xmlParser?.delegate = self
        
        resetValues()
        
        if let success = xmlParser?.parse(), success {
            completion(.success(busArrivals))
        } else {
            completion(.failure(XMLError.parseError))
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case BusArrivalXMLElementName.busArrivalList.rawValue:
            xmlElementName = .busArrivalList
            xmlDictionary = [:]
        case BusArrivalXMLElementName.flag.rawValue:
            xmlElementName = .flag
        case BusArrivalXMLElementName.locationNo1.rawValue:
            xmlElementName = .locationNo1
        case BusArrivalXMLElementName.locationNo2.rawValue:
            xmlElementName = .locationNo2
        case BusArrivalXMLElementName.lowPlate1.rawValue:
            xmlElementName = .lowPlate1
        case BusArrivalXMLElementName.lowPlate2.rawValue:
            xmlElementName = .lowPlate2
        case BusArrivalXMLElementName.plateNo1.rawValue:
            xmlElementName = .plateNo1
        case BusArrivalXMLElementName.plateNo2.rawValue:
            xmlElementName = .plateNo2
        case BusArrivalXMLElementName.predictTime1.rawValue:
            xmlElementName = .predictTime1
        case BusArrivalXMLElementName.predictTime2.rawValue:
            xmlElementName = .predictTime2
        case BusArrivalXMLElementName.remainSeatCnt1.rawValue:
            xmlElementName = .remainSeatCnt1
        case BusArrivalXMLElementName.remainSeatCnt2.rawValue:
            xmlElementName = .remainSeatCnt2
        case BusArrivalXMLElementName.routeId.rawValue:
            xmlElementName = .routeId
        case BusArrivalXMLElementName.staOrder.rawValue:
            xmlElementName = .staOrder
        case BusArrivalXMLElementName.stationId.rawValue:
            xmlElementName = .stationId
        default:
            xmlElementName = .none
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch xmlElementName {
        case .busArrivalList:
            return
        case .none:
            return
        default:
            xmlDictionary[xmlElementName.rawValue] = string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "busArrivalList" {
            guard let stationID = xmlDictionary[BusArrivalXMLElementName.stationId.rawValue],
                  let routeID = xmlDictionary[BusArrivalXMLElementName.routeId.rawValue],
                  let locationNo1 = xmlDictionary[BusArrivalXMLElementName.locationNo1.rawValue],
                  let predictTime1 = xmlDictionary[BusArrivalXMLElementName.predictTime1.rawValue],
                  let lowPlate1 = xmlDictionary[BusArrivalXMLElementName.lowPlate1.rawValue],
                  let plateNo1 = xmlDictionary[BusArrivalXMLElementName.plateNo1.rawValue],
                  let remainSeatCnt1 = xmlDictionary[BusArrivalXMLElementName.remainSeatCnt1.rawValue],
                  let staOrder = xmlDictionary[BusArrivalXMLElementName.staOrder.rawValue],
                  let flag = xmlDictionary[BusArrivalXMLElementName.flag.rawValue] else {
                      return
                  }
            
            if let locationNo2 = xmlDictionary[BusArrivalXMLElementName.locationNo2.rawValue],
               let predictTime2 = xmlDictionary[BusArrivalXMLElementName.predictTime2.rawValue],
               let lowPlate2 = xmlDictionary[BusArrivalXMLElementName.lowPlate2.rawValue],
               let plateNo2 = xmlDictionary[BusArrivalXMLElementName.plateNo2.rawValue],
               let remainSeatCnt2 = xmlDictionary[BusArrivalXMLElementName.remainSeatCnt2.rawValue] {
                
                if let index = busArrivals.firstIndex(where: { $0.routeID == routeID }) {
                    busArrivals[index] = BusArrival(
                        identity: "\(Date().timeIntervalSinceReferenceDate)",
                        stationID: stationID,
                        routeID: routeID,
                        locationNo1: locationNo1,
                        predictTime1: predictTime1,
                        lowPlate1: lowPlate1,
                        plateNo1: plateNo1,
                        remainSeatCnt1: remainSeatCnt1,
                        locationNo2: locationNo2,
                        predictTime2: predictTime2,
                        lowPlate2: lowPlate2,
                        plateNo2: plateNo2,
                        remainSeatCnt2: remainSeatCnt2,
                        staOrder: staOrder,
                        flag: flag
                    )
                } else {
                    busArrivals.append(
                        BusArrival(
                            identity: "\(Date().timeIntervalSinceReferenceDate)",
                            stationID: stationID,
                            routeID: routeID,
                            locationNo1: locationNo1,
                            predictTime1: predictTime1,
                            lowPlate1: lowPlate1,
                            plateNo1: plateNo1,
                            remainSeatCnt1: remainSeatCnt1,
                            locationNo2: locationNo2,
                            predictTime2: predictTime2,
                            lowPlate2: lowPlate2,
                            plateNo2: plateNo2,
                            remainSeatCnt2: remainSeatCnt2,
                            staOrder: staOrder,
                            flag: flag
                        )
                    )
                }
            }
            
            if !busArrivals.contains(where: { $0.routeID == routeID }) {
                busArrivals.append(
                    BusArrival(
                        identity: "\(Date().timeIntervalSinceReferenceDate)",
                        stationID: stationID,
                        routeID: routeID,
                        locationNo1: locationNo1,
                        predictTime1: predictTime1,
                        lowPlate1: lowPlate1,
                        plateNo1: plateNo1,
                        remainSeatCnt1: remainSeatCnt1,
                        locationNo2: "",
                        predictTime2: "",
                        lowPlate2: "",
                        plateNo2: "",
                        remainSeatCnt2: "",
                        staOrder: staOrder,
                        flag: flag
                    )
                )
            }
        }
    }
    
    private func resetValues() {
        xmlDictionary = [:]
        xmlElementName = .none
        busArrivals = []
    }
}
