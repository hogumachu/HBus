import Foundation

class BusRouteAPI {
    static let shared = BusRouteAPI()
    private init() {}
    
    func getBusRouteList(routeName: String, completion: @escaping (Result<[BusRoute], Error>) -> ()) {
        DispatchQueue.global().async {
            let urlString = "http://apis.data.go.kr/6410000/busrouteservice/getBusRouteList?serviceKey=\(_serviceKey)&keyword=\(routeName)"
            let url = URL(string: urlString)!
            
            BusRouteXMLParseHelper.shared.parse(url) { result in
                switch result {
                case .success(let busRouteList):
                    completion(.success(busRouteList))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getBusRouteStationList(routeID: String, completion: @escaping (Result<[BusRouteStation], Error>) -> ()) {
        DispatchQueue.global().async {
            let urlString = "http://apis.data.go.kr/6410000/busrouteservice/getBusRouteStationList?serviceKey=\(_serviceKey)&routeId=\(routeID)"
            let url = URL(string: urlString)!
            
            BusRouteStationXMLParseHelper.shared.parse(url) { result in
                switch result {
                case .success(let busRouteStationList):
                    completion(.success(busRouteStationList))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getBusLocationList(routeID: String, completion: @escaping (Result<[BusLocation], Error>) -> ()) {
        DispatchQueue.global().async {
            let urlString = "http://apis.data.go.kr/6410000/buslocationservice/getBusLocationList?serviceKey=\(_serviceKey)&routeId=\(routeID)"
            let url = URL(string: urlString)!
            
            BusLocationXMLParseHelper.shared.parse(url) { result in
                switch result {
                case .success(let busLocations):
                    completion(.success(busLocations))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getBusRouteInfoItem(routeID: String, completion: @escaping (Result<[BusRoute], Error>) -> ()) {
        let urlString = "http://apis.data.go.kr/6410000/busrouteservice/getBusRouteInfoItem?serviceKey=\(_serviceKey)&routeId=\(routeID)"
        let url = URL(string: urlString)!
        
        BusRouteInfoXMLParseHepler.shared.parse(url) { result in
            switch result {
            case .success(let busRouteList):
                completion(.success(busRouteList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getBusStationViaRouteList(stationID: String, completion: @escaping (Result<[BusRoute], Error>) -> ()) {
        DispatchQueue.global().async {
            let urlString = "http://apis.data.go.kr/6410000/busstationservice/getBusStationViaRouteList?serviceKey=\(_serviceKey)&stationId=\(stationID)"
            let url = URL(string: urlString)!
            
            BusRouteXMLParseHelper.shared.parse(url) { result in
                switch result {
                case .success(let busRouteList):
                    completion(.success(busRouteList))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
