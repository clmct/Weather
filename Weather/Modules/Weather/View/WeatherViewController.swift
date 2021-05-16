import UIKit
import NotificationBannerSwift

final class WeatherViewController: UIViewController {
  // MARK: Properties
  var viewModel: WeatherViewModelProtocol?
  private let pressureView = WeatherComponentView()
  private let windView = WeatherComponentView()
  private let humidityView = WeatherComponentView()
  private let iconView = WeatherIconComponentView()
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
    viewModel?.viewControllerDidClose()
  }
  
  // MARK: Binding
  private func bindToViewModel() {
    viewModel?.didRequestUpdateView = { [weak self] in
      guard let self = self else { return }
      guard let data = self.viewModel?.data else { return }
      self.updateView(data: data)
      if let description = data.description,
         let image = UIImage(named: description) {
        self.setImage(image)
      } else {
        self.setDefaultImage()
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
    
    viewModel?.didRequestShowError = { [weak self] networkError in
      self?.showError(networkError: networkError)
    }
  }
  
  private func showError(networkError: NetworkError) {
    showNetworkError(networkError: networkError) { [weak self] in
      self?.viewModel?.getWeather()
    }
  }
  
  // MARK: Actions
  private func updateView(data: WeatherViewModelData) {
    title = data.cityName
    degreesCelsiusLabel.text = "\(data.temperature)"
    degreesCelsiusSymbolLabel.text = "\u{2103}"
    pressureView.configure(title: R.string.localizable.pressure(),
                           description: "\(data.pressure) \(R.string.localizable.pressureUnitOfMeasurement())")
    windView.configure(title: R.string.localizable.wind(),
                       description: "\(data.windDeg) \(data.windSpeed) \(R.string.localizable.windUnitOfMeasurement())")
    humidityView.configure(title: R.string.localizable.humidity(),
                           description: "\(data.humidity)%")
    iconView.configure(image: data.icon,
                       title: data.description)
  }
  
  private func setImage(_ image: UIImage) {
    imageView.image = image
  }
  
  private func setDefaultImage() {
    imageView.image = R.image.brokenClouds()
    let banner = NotificationBanner(title: R.string.localizable.errorImageTitle(),
                                    subtitle: R.string.localizable.errorImageSubtitle(),
                                    style: .info)
    banner.show()
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
    mask.contents = R.image.mask()?.cgImage
    mask.frame = CGRect(x: 0, y: 0, width: 240, height: 576)
    imageView.layer.mask = mask
    imageView.layer.masksToBounds = true
  }
}
