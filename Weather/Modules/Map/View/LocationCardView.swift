import UIKit

final class LocationCardView: UIView {
  // MARK: Properties
  private let locationNameLabel = UILabel()
  private let locationCoordinateLabel = UILabel()
  private let showWeatherButton = UIButton(type: .system)
  private let closeButton = UIButton(type: .system)
  var didTapShowWeather: (() -> Void)?
  var didTapCloseView: (() -> Void)?
  
  // MARK: Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Methods
  func configure(city: String, coordinateDescription: String) {
    locationNameLabel.text = city
    locationCoordinateLabel.text = coordinateDescription
  }
  
  // MARK: Actions
  @objc
  private func showWeather() {
    didTapShowWeather?()
  }
  
  @objc
  private func closeView() {
    didTapCloseView?()
  }
  
  // MARK: Layout
  private func setupView() {
    setupLayer()
    setupLocationNameLabel()
    setupLocationCoordinateLabel()
    setupShowWeatherButton()
    setupCloseButton()
  }
  
  private func setupLayer() {
    layer.cornerRadius = 8
    layer.shadowColor = UIColor.basic8.cgColor
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
    
    showWeatherButton.setTitle(R.string.localizable.mapCardViewButton(), for: .normal)
    showWeatherButton.setTitleColor(.basic3, for: .normal)
    showWeatherButton.layer.cornerRadius = 22
    showWeatherButton.layer.borderWidth = 1
    showWeatherButton.layer.borderColor = UIColor.basic3.cgColor
    
    showWeatherButton.addTarget(self, action: #selector(showWeather), for: .touchUpInside)
  }
  
  private func setupCloseButton() {
    addSubview(closeButton)
    closeButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.trailing.equalToSuperview().offset(-20)
    }
    
    closeButton.setImage(R.image.close(), for: .normal)
    closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
  }
}
