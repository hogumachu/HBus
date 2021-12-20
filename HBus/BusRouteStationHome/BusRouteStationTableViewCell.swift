import UIKit
import SnapKit

class BusRouteStationTableViewCell: UITableViewCell {
    static let identifier = "BusRouteStationTableViewCellIdentifier"
    
    private var isBus = false
    
    private let backgroundWrapView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        return view
    }()
    private let stationNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private let stationIDLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = .lightGray
        return label
    }()
    private let busWrapView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemOrange
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .continuous
        return view
    }()
    private let busStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .trailing
        return stack
    }()
    private let busImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "bus")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    private let busLabel: UILabel = {
        let label = UILabel()
        label.text = "도착 예정"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray6
        return label
    }()
    private let busSeatCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    private let turnImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "arrow.uturn.down.circle.fill")?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .systemGray4
        setBus(false)
    }
    
    private func configureUI() {
        backgroundColor = .systemGray4
        addSubview(backgroundWrapView)
        backgroundWrapView.addSubview(stationNameLabel)
        backgroundWrapView.addSubview(stationIDLabel)
        backgroundWrapView.addSubview(busWrapView)
        backgroundWrapView.addSubview(turnImageView)
        
        busWrapView.addSubview(busStackView)
        
        busStackView.addArrangedSubview(busImageView)
        busStackView.addArrangedSubview(busSeatCountLabel)
        busStackView.addArrangedSubview(busLabel)
        
        backgroundWrapView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(5)
            $0.trailing.bottom.equalToSuperview().offset(-5)
        }
        
        stationNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(35)
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalTo(snp.centerX).offset(-5)
        }
        
        stationIDLabel.snp.makeConstraints {
            $0.top.equalTo(stationNameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(stationNameLabel)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        busWrapView.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(snp.centerX).offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalTo(snp.centerY)
        }
        
        busStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(5)
            $0.trailing.bottom.equalToSuperview().offset(-5)
        }
        
        busImageView.snp.makeConstraints {
            $0.height.width.equalTo(20)
        }
        
        turnImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(3)
            $0.width.height.equalTo(25)
        }
    }
    
    func setBus(_ bus: Bool, count: String = "0") {
        isBus = bus
        
        if !isBus {
            busWrapView.isHidden = true
        } else {
            busWrapView.isHidden = false
            
            if count == "-1" {
                busSeatCountLabel.text = ""
            } else {
                busSeatCountLabel.text = "\(count)석"
            }
        }
    }
    
    
    func setItem(item: BusRouteStation) {
        stationNameLabel.text = item.stationName
        stationIDLabel.text = item.stationID
        
        if item.turnYn == "Y" {
            turnImageView.isHidden = false
        } else {
            turnImageView.isHidden = true
        }
        
        setBus(isBus)
    }
}
