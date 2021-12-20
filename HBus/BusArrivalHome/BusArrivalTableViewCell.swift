import UIKit

class BusArrivalTableViewCell: UITableViewCell {
    static let identifier = "BusArrivalTableViewCellIdentifier"
    
    // MARK: - Properties
    
    private let backgroundWrapView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        return view
    }()
    private let routeNameCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemOrange
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .continuous
        return view
    }()
    private let routeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    private let arrivalStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalCentering
        stack.alignment = .trailing
        stack.spacing = 3
        return stack
    }()
    private let firstArrivalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 3
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }()
    private let firstLocationNoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    private let firstTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let firstSeatLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemOrange
        return label
    }()
    private let secondArrivalStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 3
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        return stack
    }()
    private let secondLocationNoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    private let secondTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let secondSeatLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemOrange
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        backgroundColor = .systemGray4
        
        addSubview(backgroundWrapView)
        
        backgroundWrapView.addSubview(routeNameCardView)
        backgroundWrapView.addSubview(arrivalStackView)
        
        routeNameCardView.addSubview(routeNameLabel)
        
        arrivalStackView.addArrangedSubview(firstArrivalStackView)
        arrivalStackView.addArrangedSubview(secondArrivalStackView)
        
        firstArrivalStackView.addArrangedSubview(firstTimeLabel)
        firstArrivalStackView.addArrangedSubview(firstLocationNoLabel)
        firstArrivalStackView.addArrangedSubview(firstSeatLabel)
        
        secondArrivalStackView.addArrangedSubview(secondTimeLabel)
        secondArrivalStackView.addArrangedSubview(secondLocationNoLabel)
        secondArrivalStackView.addArrangedSubview(secondSeatLabel)
        
        backgroundWrapView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(5)
            $0.trailing.bottom.equalToSuperview().offset(-5)
            $0.height.equalTo(80)
        }
        
        routeNameCardView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalTo(backgroundWrapView.snp.centerX).offset(-10)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        routeNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        arrivalStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(routeNameLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func setItem(item: BusArrivalName) {
        routeNameLabel.text = item.routeName
        
        if item.routeName == "-" {
            hiddenArrivals()
        }
        
        if item.busArrival.predictTime1.isEmpty {
            hiddenArrivals()
            return
        }
        
        firstTimeLabel.text = "\(item.busArrival.predictTime1)분"
        firstLocationNoLabel.text = "\(item.busArrival.locationNo1)번째전"
        
        if !item.busArrival.remainSeatCnt1.isEmpty && item.busArrival.remainSeatCnt1 != "-1" {
            firstSeatLabel.text = "\(item.busArrival.remainSeatCnt1)석"
        }
        
        if item.busArrival.locationNo2.isEmpty {
            secondArrivalStackView.isHidden = true
        } else {
            secondArrivalStackView.isHidden = false
            secondTimeLabel.text = "\(item.busArrival.predictTime2)분"
            secondLocationNoLabel.text = "\(item.busArrival.locationNo2)번째전"
            
            if !item.busArrival.remainSeatCnt2.isEmpty && item.busArrival.remainSeatCnt2 != "-1" {
                secondSeatLabel.text = "\(item.busArrival.remainSeatCnt2)석"
            }
        }
    }
    
    private func hiddenArrivals() {
        firstTimeLabel.text = ""
        firstLocationNoLabel.text = "도착 예정 없음"
        firstSeatLabel.text = ""
        secondArrivalStackView.isHidden = true
    }
}
