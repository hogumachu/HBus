import Foundation

class BusRouteInfoXMLParseHepler: NSObject, XMLParserDelegate {
    static let shared = BusRouteInfoXMLParseHepler()
    private override init() {}
    private var xmlDictionary: [String: String] = [:]
    private var xmlElementName = BusRouteXMLElementName.none
    private var busRoutes: [BusRoute] = []
    
    func parse(_ url: URL, completion: @escaping (Result<[BusRoute], Error>) -> ()) {
        let xmlParser = XMLParser(contentsOf: url)
        xmlParser?.delegate = self
        
        resetValues()
        
        if let success = xmlParser?.parse(), success {
            completion(.success(busRoutes))
        } else {
            completion(.failure(XMLError.parseError))
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        switch elementName {
        case BusRouteXMLElementName.busRouteList.rawValue:
            xmlElementName = .busRouteList
            xmlDictionary = [:]
        case BusRouteXMLElementName.routeID.rawValue:
            xmlElementName = .routeID
        case BusRouteXMLElementName.routeName.rawValue:
            xmlElementName = .routeName
        case BusRouteXMLElementName.routeTypeCd.rawValue:
            xmlElementName = .routeTypeCd
        case BusRouteXMLElementName.routeTypeName.rawValue:
            xmlElementName = .routeTypeName
        case BusRouteXMLElementName.regionName.rawValue:
            xmlElementName = .regionName
        case BusRouteXMLElementName.districtCd.rawValue:
            xmlElementName = .districtCd
        default:
            xmlElementName = .none
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch xmlElementName {
        case .busRouteList:
            return
        case .none:
            return
        default:
            xmlDictionary[xmlElementName.rawValue] = string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "busRouteInfoItem" {
            guard let routeID = xmlDictionary[BusRouteXMLElementName.routeID.rawValue],
                  let routeName = xmlDictionary[BusRouteXMLElementName.routeName.rawValue],
                  let routeTypeCd = xmlDictionary[BusRouteXMLElementName.routeTypeCd.rawValue],
                  let routeTypeName = xmlDictionary[BusRouteXMLElementName.routeTypeName.rawValue],
                  let regionName = xmlDictionary[BusRouteXMLElementName.regionName.rawValue],
                  let districtCd = xmlDictionary[BusRouteXMLElementName.districtCd.rawValue] else {
                      return
                  }
            
            busRoutes.append(
                BusRoute(
                    identity: "\(Date().timeIntervalSinceReferenceDate)",
                    routeID: routeID,
                    routeName: routeName,
                    routeTypeCd: routeTypeCd,
                    routeTypeName: routeTypeName,
                    regionName: regionName,
                    districtCd: districtCd
                )
            )
        }
    }
    
    private func resetValues() {
        xmlDictionary = [:]
        xmlElementName = .none
        busRoutes = []
    }
}


