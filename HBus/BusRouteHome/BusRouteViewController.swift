import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxKeyboard

class BusRouteViewController: UIViewController {
    // MARK: - Dependency
    
    struct Dependency {
        let coordinator: Coordinator
        let viewModel: BusRouteViewModel
    }
    
    private let coordinator: Coordinator
    private let viewModel: BusRouteViewModel
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.isHidden = true
        return indicatorView
    }()
    private let routeSearchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "버스 검색"
        return textField
    }()
    private let routeTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BusRouteTableViewCell.self, forCellReuseIdentifier: BusRouteTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGray4
        return tableView
    }()
    
    // MARK: - Lifecycles
    
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
    
    // MARK: - Configure
    
    private func configureUI() {
        navigationItem.title = "버스 검색"
        view.backgroundColor = .systemGray4
        
        view.addSubview(routeSearchTextField)
        view.addSubview(routeTableView)
        view.addSubview(indicatorView)
        
        routeSearchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(5)
            $0.trailing.equalTo(view.safeAreaInsets).offset(-5)
            $0.height.equalTo(40)
        }
        
        routeTableView.snp.makeConstraints {
            $0.top.equalTo(routeSearchTextField.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        indicatorView.snp.makeConstraints {
            $0.center.equalTo(routeTableView)
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        viewModel.busRouteList
            .bind(to: routeTableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        routeTableView.rx.itemSelected
            .bind(
                with: self,
                onNext: { vc, indexPath in
                    vc.routeTableView.deselectRow(at: indexPath, animated: true)
                    vc.coordinator.busRouteStationVC(busRoute: vc.viewModel.item(at: indexPath), animated: true)
                }
            )
            .disposed(by: disposeBag)
        
        routeSearchTextField.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .compactMap { String($0) }
            .bind(
                with: viewModel,
                onNext: { viewModel, text in
                    viewModel.searchBusRoute(routeName: text)
                }
            )
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(
                with: self,
                onNext: { vc, height in
                    vc.routeTableView.snp.updateConstraints {
                        $0.bottom.equalTo(vc.view.safeAreaLayoutGuide).offset(-height)
                    }
                    vc.view.layoutIfNeeded()
                }
            )
            .disposed(by: disposeBag)
        
        viewModel.loadingObservable
            .asDriver(onErrorJustReturn: false)
            .drive(
                with: self,
                onNext: { vc, isLoading in
                    isLoading ? vc.startLoading() : vc.stopLoading()
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: - Helper
    
    private func startLoading() {
        indicatorView.isHidden = false
        indicatorView.startAnimating()
    }
    
    private func stopLoading() {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
    }
}
