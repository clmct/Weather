import UIKit

final class LocationCardView: UIView {
  private let locationNameLabel = UILabel()
  private let locationCoordinateLabel = UILabel()
  private let showWeatherButton = UIButton(type: .system)
  private let closeCardViewButton = UIButton(type: .system)
  var didTapShowWeather: (() -> Void)?
  var didTapCloseView: (() -> Void)?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(city: String, coordinate: String) {
    locationNameLabel.text = city
    locationCoordinateLabel.text = coordinate
  }
  
  @objc
  func showWeather() {
    didTapShowWeather?()
  }
  
  @objc
  func closeView() {
    didTapCloseView?()
  }
  
  private func setupView() {
    locationNameLabel.text = "Milan"
    locationCoordinateLabel.text = "45°16'44.7 N 9°43'33.2E"
    setupLayer()
    setupLocationNameLabel()
    setupLocationCoordinateLabel()
    setupShowWeatherButton()
    setupCloseCardViewButton()
  }
  
  private func setupLayer() {
    layer.cornerRadius = 8
    layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.31).cgColor
    layer.shadowOpacity = 1
    layer.shadowOffset = .zero
    layer.shadowRadius = 16
    layer.cornerCurve = .continuous
  }
  
  private func setupLocationNameLabel() {
    addSubview(locationNameLabel)
    locationNameLabel.snp.makeConstraints { make in
      make.leading.top.equalToSuperview().offset(16)
    }
    
    locationNameLabel.font = .basic1
    locationNameLabel.textColor = .basic1
  }
  
  private func setupLocationCoordinateLabel() {
    addSubview(locationCoordinateLabel)
    locationCoordinateLabel.snp.makeConstraints { make in
      make.leading.equalTo(locationNameLabel)
      make.top.equalTo(locationNameLabel.snp.bottom).offset(2)
    }
    
    locationCoordinateLabel.font = .basic2
    locationCoordinateLabel.textColor = .basic2
  }
  
  private func setupShowWeatherButton() {
    addSubview(showWeatherButton)
    showWeatherButton.snp.makeConstraints { make in
      make.leading.equalTo(locationNameLabel)
      make.trailing.equalToSuperview().offset(-16)
      make.bottom.equalToSuperview().offset(-16)
      make.height.equalTo(44)
    }
    
    showWeatherButton.setTitle("Show Weather", for: .normal)
    showWeatherButton.setTitleColor(.basic3, for: .normal)
    showWeatherButton.layer.cornerRadius = 22
    showWeatherButton.layer.borderWidth = 1
    showWeatherButton.layer.borderColor = UIColor.basic3.cgColor
    
    showWeatherButton.addTarget(self, action: #selector(showWeather), for: .touchUpInside)
  }
  
  private func setupCloseCardViewButton() {
    addSubview(closeCardViewButton)
    closeCardViewButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
    }
    
    closeCardViewButton.setImage(UIImage(named: "close"), for: .normal)
    
    closeCardViewButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
  }
  
}
