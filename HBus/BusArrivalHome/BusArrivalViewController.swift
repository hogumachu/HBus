import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BusArrivalViewController: UIViewController {
    // MARK: - Dependency
    
    struct Dependency {
        let coordinator: Coordinator
        let viewModel: BusArrivalViewModel
    }
    
    private let coordinator: Coordinator
    private let viewModel: BusArrivalViewModel
    
    // MARK: - Properties
    
    private var timerObservable: Disposable?
    private let disposeBag = DisposeBag()
    private let arrivalTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BusArrivalTableViewCell.self, forCellReuseIdentifier: BusArrivalTableViewCell.identifier)
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
        viewModel.getBusArrival()
        setTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeTimer()
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        navigationItem.title = viewModel.busRouteStaion.stationName
        view.backgroundColor = .systemGray4
        
        view.addSubview(arrivalTableView)
        
        arrivalTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        viewModel.busArrivalList
            .bind(to: arrivalTableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        arrivalTableView.rx.modelSelected(BusArrivalName.self)
            .bind(
                with: self,
                onNext: { vc, item in
                    vc.viewModel.getBusRoute(item: item.busArrival) { busRoute in
                        if let busRoute = busRoute {
                            vc.coordinator.busRouteStationVC(busRoute: busRoute, animated: true)
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
                    vc.viewModel.getBusArrival()
                    vc.arrivalTableView.reloadData()
                }
            )
    }
    
    private func removeTimer() {
        timerObservable?.dispose()
    }
}
