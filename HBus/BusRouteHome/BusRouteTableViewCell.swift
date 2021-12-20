import UIKit

class BusRouteTableViewCell: UITableViewCell {
    static let identifier = "BusRouteTableViewCellIdentifier"
    
    private let backgroundWrapView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        return view
    }()
    private let routeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()
    private let regionNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemOrange
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .systemGray4
        addSubview(backgroundWrapView)
        backgroundWrapView.addSubview(routeNameLabel)
        backgroundWrapView.addSubview(regionNameLabel)
        
        backgroundWrapView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(5)
            $0.trailing.bottom.equalToSuperview().offset(-5)
        }
        
        routeNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
        }
        
        regionNameLabel.snp.makeConstraints {
            $0.top.equalTo(routeNameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(routeNameLabel)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func setItem(item: BusRoute) {
        routeNameLabel.text = item.routeName
        regionNameLabel.text = item.regionName
    }
}
