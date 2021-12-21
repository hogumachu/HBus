import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BusRouteStationViewController: UIViewController {
    // MARK: - Dependency
    
    struct Dependency {
        let coordinator: Coordinator
        let viewModel: BusRouteStationViewModel
    }
    
    private let coordinator: Coordinator
    private let viewModel: BusRouteStationViewModel
    
    // MARK: - Properties
    
    private var timerObservable: Disposable?
    private let disposeBag = DisposeBag()
    private let stationTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BusRouteStationTableViewCell.self, forCellReuseIdentifier: BusRouteStationTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGray4
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    init(dependency: Dependency) {
        self.coordinator = dependency.coordinator
        self.viewModel = dependency.viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadBusLocationList()
        setTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTimer()
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        navigationItem.title = viewModel.busRoute.routeName
        view.backgroundColor = .systemGray4
        
        view.addSubview(stationTableView)
        
        stationTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        viewModel.searchBusStationList()
        viewModel.busRouteStationList
            .bind(to: stationTableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        stationTableView.rx.modelSelected(BusRouteStation.self)
            .bind(
                with: self,
                onNext: { vc, item in
                    vc.viewModel.getBusStationViaRoute(stationID: item.stationID) { busRoutes in
                        if let busRoutes = busRoutes {
                            DispatchQueue.main.async {
                                vc.coordinator.busArrivalVC(station: item, busRoutes: busRoutes, animated: true)
                            }
                        }
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helper
    
    private func setTimer() {
        timerObservable = Observable<Int>.interval(.seconds(30), scheduler: MainScheduler.instance)
            .bind(
                with: self,
                onNext: { vc, _  in
                    vc.viewModel.loadBusLocationList()
                    vc.stationTableView.reloadData()
                }
            )
    }
    
    private func removeTimer() {
        timerObservable?.dispose()
    }
}
