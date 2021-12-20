import UIKit

struct AppDependency {
    let window: UIWindow
    let coordinator: Coordinator
}

extension AppDependency {
    static func resolve(window: UIWindow) -> AppDependency {
        let mainNavigationController: UINavigationController = {
            return .init(nibName: nil, bundle: nil)
        }()
        let busRouteViewControllerFactory: (BusRouteViewController.Dependency) -> BusRouteViewController = { dependency in
            return .init(dependency: dependency)
        }
        let busRouteStationViewControllerFactory: (BusRouteStationViewController.Dependency) -> BusRouteStationViewController = { dependency in
            return .init(dependency: dependency)
        }
        let busArrivalViewControllerFactory: (BusArrivalViewController.Dependency) -> BusArrivalViewController = { dependency in
            return .init(dependency: dependency)
        }
        
        return .init(
            window: window,
            coordinator: .init(
                dependency: .init(
                    mainNavigationController: mainNavigationController,
                    busRouteViewControllerFactory: busRouteViewControllerFactory,
                    busRouteStationViewControllerFactory: busRouteStationViewControllerFactory,
                    busArrivalViewControllerFactory: busArrivalViewControllerFactory
                )
            )
        )
    }
    
    func start() {
        coordinator.start(window: window)
    }
}
