import Foundation

class BusLocationXMLParseHelper: NSObject, XMLParserDelegate {
    static let shared = BusLocationXMLParseHelper()
    private override init() {}
    private var xmlDictionary: [String: String] = [:]
    private var xmlElementName = BusLocationXMLElementName.none
    private var busLocations: [BusLocation] = []
    
    func parse(_ url: URL, completion: @escaping (Result<[BusLocation], Error>) -> ()) {
        let xmlParser = XMLParser(contentsOf: url)
        xmlParser?.delegate = self
        
        resetValues()
        
        if let success = xmlParser?.parse(), success {
            completion(.success(busLocations))
        } else {
            completion(.failure(XMLError.parseError))
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case BusLocationXMLElementName.busLocationList.rawValue:
            xmlElementName = .busLocationList
            xmlDictionary = [:]
        case BusLocationXMLElementName.routeID.rawValue:
            xmlElementName = .routeID
        case BusLocationXMLElementName.stationID.rawValue:
            xmlElementName = .stationID
        case BusLocationXMLElementName.stationSeq.rawValue:
            xmlElementName = .stationSeq
        case BusLocationXMLElementName.endBus.rawValue:
            xmlElementName = .endBus
        case BusLocationXMLElementName.lowPlate.rawValue:
            xmlElementName = .lowPlate
        case BusLocationXMLElementName.plateNo.rawValue:
            xmlElementName = .plateNo
        case BusLocationXMLElementName.plateType.rawValue:
            xmlElementName = .plateType
        case BusLocationXMLElementName.remainSeatCnt.rawValue:
            xmlElementName = .remainSeatCnt
        default:
            xmlElementName = .none
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch xmlElementName {
        case .busLocationList:
            return
        case .none:
            return
        default:
            xmlDictionary[xmlElementName.rawValue] = string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "busLocationList" {
            guard let routeID = xmlDictionary[BusLocationXMLElementName.routeID.rawValue],
                  let stationID = xmlDictionary[BusLocationXMLElementName.stationID.rawValue],
                  let stationSeq = xmlDictionary[BusLocationXMLElementName.stationSeq.rawValue],
                  let endBus = xmlDictionary[BusLocationXMLElementName.endBus.rawValue],
                  let lowPlate = xmlDictionary[BusLocationXMLElementName.lowPlate.rawValue],
                  let plateNo = xmlDictionary[BusLocationXMLElementName.plateNo.rawValue],
                  let plateType = xmlDictionary[BusLocationXMLElementName.plateType.rawValue],
                  let remainSeatCnt = xmlDictionary[BusLocationXMLElementName.remainSeatCnt.rawValue] else {
                      return
                  }
            
            busLocations.append(
                BusLocation(
                    routeID: routeID,
                    stationID: stationID,
                    stationSeq: stationSeq,
                    endBus: endBus,
                    lowPlate: lowPlate,
                    plateNo: plateNo,
                    plateType: plateType,
                    remainSeatCnt: remainSeatCnt
                )
            )
        }
    }
    
    private func resetValues() {
        xmlDictionary = [:]
        xmlElementName = .none
        busLocations = []
    }
}
