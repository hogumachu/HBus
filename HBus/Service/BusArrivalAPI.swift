import Foundation

class BusArrivalAPI {
    static let shared = BusArrivalAPI()
    private init() {}
    
    func getBusArrivalList(stationID: String, completion: @escaping (Result<[BusArrival], Error>) ->()) {
        DispatchQueue(label: "getBusArrivalList").async {
            let urlString = "http://apis.data.go.kr/6410000/busarrivalservice/getBusArrivalList?serviceKey=\(_serviceKey)&stationId=\(stationID)"
            let url = URL(string: urlString)!
            
            BusArrivalXMLParseHelper.shared.parse(url) { result in
                switch result {
                case .success(let busArrivals):
                    completion(.success(busArrivals))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
