import UIKit

class Coordinator {
    
    // MARK: - Scene Dependency
    
    struct Dependency {
        let mainNavigationController: UINavigationController
        let busRouteViewControllerFactory: (BusRouteViewController.Dependency) -> BusRouteViewController
        let busRouteStationViewControllerFactory: (BusRouteStationViewController.Dependency) -> BusRouteStationViewController
        let busArrivalViewControllerFactory: (BusArrivalViewController.Dependency) -> BusArrivalViewController
    }
    
    private let mainNavigationController: UINavigationController
    private let busRouteViewControllerFactory: (BusRouteViewController.Dependency) -> BusRouteViewController
    private let busRouteStationViewControllerFactory: (BusRouteStationViewController.Dependency) -> BusRouteStationViewController
    private let busArrivalViewControllerFactory: (BusArrivalViewController.Dependency) -> BusArrivalViewController
    
    init(dependency: Dependency) {
        self.mainNavigationController = dependency.mainNavigationController
        self.busRouteViewControllerFactory = dependency.busRouteViewControllerFactory
        self.busRouteStationViewControllerFactory = dependency.busRouteStationViewControllerFactory
        self.busArrivalViewControllerFactory = dependency.busArrivalViewControllerFactory
    }
}

extension Coordinator {
    func start(window: UIWindow) {
        let routeVC = busRouteViewControllerFactory(.init(coordinator: self , viewModel: .init()))
        
        mainNavigationController.setViewControllers([routeVC], animated: false)
        
        window.rootViewController = mainNavigationController
        window.makeKeyAndVisible()
    }
    
    func busRouteStationVC(busRoute: BusRoute, animated: Bool) {
        let routeStationVC = busRouteStationViewControllerFactory(.init(coordinator: self, viewModel: .init(dependency: .init(busRoute: busRoute))))
        
        mainNavigationController.pushViewController(routeStationVC, animated: animated)
    }
    
    func busArrivalVC(station: BusRouteStation, busRoutes: [BusRoute], animated: Bool) {
        let busArrivalVC = busArrivalViewControllerFactory(.init(coordinator: self, viewModel: .init(dependency: .init(busRouteStaion: station, busRoutes: busRoutes))))
        
        mainNavigationController.pushViewController(busArrivalVC, animated: animated)
    }
}
