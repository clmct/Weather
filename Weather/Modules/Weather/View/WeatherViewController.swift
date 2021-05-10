import UIKit
import NotificationBannerSwift

final class WeatherViewController: UIViewController {
  // MARK: Properties
  var viewModel: WeatherViewModelProtocol?
  private let pressureView = WeatherComponent()
  private let windView = WeatherComponent()
  private let humidityView = WeatherComponent()
  private let iconView = WeatherIconComponent()
  private let degreesCelsiusLabel = UILabel()
  private let degreesCelsiusSymbolLabel = UILabel()
  private let loader = UIActivityIndicatorView(style: .medium)
  private let imageView = UIImageView()
  
  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    bindToViewModel()
    viewModel?.getWeather()
  }
  
  deinit {
    viewModel?.closeViewController()
  }
  
  // MARK: Binding
  private func bindToViewModel() {
    viewModel?.updateView = { [weak self] in
      guard let self = self else { return }
      guard let pressure = self.viewModel?.pressure,
            let windDeg = self.viewModel?.windDeg,
            let windSpeed = self.viewModel?.windSpeed,
            let humidity = self.viewModel?.humidity,
            let temp = self.viewModel?.temperature,
            let name = self.viewModel?.cityName,
            let description = self.viewModel?.description,
            let icon = self.viewModel?.icon else { return }
      self.title = name
      self.degreesCelsiusLabel.text = "\(temp)"
      self.degreesCelsiusSymbolLabel.text = "\u{2103}"
      self.pressureView.configure(title: "PRESSURE", description: "\(pressure) mm Hg")
      self.windView.configure(title: "WIND", description: "\(windDeg) \(windSpeed) m/s")
      self.humidityView.configure(title: "HUMIDITY", description: "\(humidity)%")
      self.iconView.configure(image: icon, title: description)
      if let image = UIImage(named: description) {
        self.imageView.image = image
      } else {
        self.imageView.image = UIImage(named: "broken clouds")
        let banner = NotificationBanner(title: "Image", subtitle: "Default image had loaded", style: .info)
        banner.show()
      }
    }
    
    viewModel?.didRequestStart = { [weak self] in
      guard let self = self else { return }
      self.loader.startAnimating()
    }
    
    viewModel?.didRequestEnd = { [weak self] in
      guard let self = self else { return }
      self.loader.stopAnimating()
    }
  }
  
  // MARK: Layout
  private func setupLayout() {
    view.backgroundColor = .white
    setupImageView()
    setupPressureView()
    setupWindView()
    setupHumidityView()
    setupIconView()
    setupDegreesCelsiusLabel()
    setupDegreesCelsiusSymbolLabel()
    setupLoader()
  }
  
  private func setupLoader() {
    view.addSubview(loader)
    view.bringSubviewToFront(loader)
    loader.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
    }
  }
  
  private func setupDegreesCelsiusLabel() {
    view.addSubview(degreesCelsiusLabel)
    degreesCelsiusLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(15)
      make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
      make.height.equalTo(143)
    }
    degreesCelsiusLabel.textColor = .basic6
    degreesCelsiusLabel.font = .basic7
  }
  
  private func setupDegreesCelsiusSymbolLabel() {
    view.addSubview(degreesCelsiusSymbolLabel)
    degreesCelsiusSymbolLabel.snp.makeConstraints { make in
      make.leading.equalTo(degreesCelsiusLabel.snp.trailing)
      make.top.equalTo(degreesCelsiusLabel.snp.top)
      make.height.width.equalTo(100)
    }
    degreesCelsiusSymbolLabel.textColor = .basic7
    degreesCelsiusSymbolLabel.font = .basic8
  }
  
  private func setupIconView() {
    view.addSubview(iconView)
    iconView.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(15)
      make.bottom.equalTo(humidityView.snp.top).offset(-28)
      make.width.equalTo(110)
      make.height.equalTo(100)
    }
  }
  
  private func setupPressureView() {
    view.addSubview(pressureView)
    pressureView.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-21)
      make.leading.equalToSuperview().offset(15)
      make.width.equalTo(140)
      make.height.equalTo(50)
    }
  }
  
  private func setupWindView() {
    view.addSubview(windView)
    windView.snp.makeConstraints { make in
      make.bottom.equalTo(pressureView.snp.top).offset(-40)
      make.leading.equalToSuperview().offset(15)
      make.width.equalTo(140)
      make.height.equalTo(50)
    }
  }
  
  private func setupHumidityView() {
    view.addSubview(humidityView)
    humidityView.snp.makeConstraints { make in
      make.bottom.equalTo(windView.snp.top).offset(-40)
      make.leading.equalToSuperview().offset(15)
      make.width.equalTo(140)
      make.height.equalTo(50)
    }
  }
  
  private func setupImageView() {
    view.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.bottom.trailing.equalToSuperview()
      make.width.equalTo(240)
      make.height.equalTo(576)
    }
    imageView.contentMode = .bottomRight
    let mask = CALayer()
    mask.contents = UIImage(named: "Mask")?.cgImage
    mask.frame = CGRect(x: 0, y: 0, width: 240, height: 576)
    imageView.layer.mask = mask
    imageView.layer.masksToBounds = true
  }
}
