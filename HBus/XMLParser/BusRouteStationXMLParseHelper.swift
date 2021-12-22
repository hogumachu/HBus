import Foundation

class BusRouteStationXMLParseHelper: NSObject, XMLParserDelegate {
    static let shared = BusRouteStationXMLParseHelper()
    private override init() {}
    private var xmlDictionary: [String: String] = [:]
    private var xmlElementName = BusRouteStationXMLElementName.none
    private var busRouteStations: [BusRouteStation] = []
    
    func parse(_ url: URL, completion: @escaping (Result<[BusRouteStation], Error>) -> ()) {
        let xmlParser = XMLParser(contentsOf: url)
        xmlParser?.delegate = self
        
        resetValues()
        
        if let success = xmlParser?.parse(), success {
            completion(.success(busRouteStations))
        } else {
            completion(.failure(XMLError.parseError))
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case BusRouteStationXMLElementName.busRouteStationList.rawValue:
            xmlElementName = .busRouteStationList
            xmlDictionary = [:]
        case BusRouteStationXMLElementName.stationID.rawValue:
            xmlElementName = .stationID
        case BusRouteStationXMLElementName.stationSeq.rawValue:
            xmlElementName = .stationSeq
        case BusRouteStationXMLElementName.stationName.rawValue:
            xmlElementName = .stationName
        case BusRouteStationXMLElementName.regionName.rawValue:
            xmlElementName = .regionName
        case BusRouteStationXMLElementName.districtCd.rawValue:
            xmlElementName = .districtCd
        case BusRouteStationXMLElementName.centerYn.rawValue:
            xmlElementName = .centerYn
        case BusRouteStationXMLElementName.turnYn.rawValue:
            xmlElementName = .turnYn
        default:
            xmlElementName = .none
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch xmlElementName {
        case .busRouteStationList:
            return
        case .none:
            return
        default:
            xmlDictionary[xmlElementName.rawValue] = string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "busRouteStationList" {
            guard let stationID = xmlDictionary[BusRouteStationXMLElementName.stationID.rawValue],
                  let stationSeq = xmlDictionary[BusRouteStationXMLElementName.stationSeq.rawValue],
                  let stationName = xmlDictionary[BusRouteStationXMLElementName.stationName.rawValue],
                  let regionName = xmlDictionary[BusRouteStationXMLElementName.regionName.rawValue],
                  let districtCd = xmlDictionary[BusRouteStationXMLElementName.districtCd.rawValue],
                  let centerYn = xmlDictionary[BusRouteStationXMLElementName.centerYn.rawValue],
                  let turnYn = xmlDictionary[BusRouteStationXMLElementName.turnYn.rawValue] else {
                      return
                  }
            
            busRouteStations.append(
                BusRouteStation(
                    identity: "\(Date().timeIntervalSinceReferenceDate)",
                    stationID: stationID,
                    stationSeq: stationSeq,
                    stationName: stationName,
                    regionName: regionName,
                    districtCd: districtCd,
                    centerYn: centerYn,
                    turnYn: turnYn
                )
            )
        }
    }
    
    private func resetValues() {
        xmlDictionary = [:]
        xmlElementName = .none
        busRouteStations = []
    }
}
