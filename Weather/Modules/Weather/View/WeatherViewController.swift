import UIKit

final class WeatherViewController: UIViewController {
  var viewModel: WeatherViewModelProtocol?
  
  private let pressureView = WeatherComponent()
  private let windView = WeatherComponent()
  private let humidityView = WeatherComponent()
  private let iconView = WeatherIconComponent()
  private let degreesCelsiusLabel = UILabel()
  private let degreesCelsiusSymbolLabel = UILabel()
  private let loader = UIActivityIndicatorView(style: .medium)
  
  private let imageView = UIImageView()
  private let mask = UIImage()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayout()
    bindToViewModel()
    viewModel?.getWeather()
  }
  
  // MARK: BindToViewModel
  private func bindToViewModel() {
    viewModel?.updateView = { [weak self] in
      guard let self = self else { return }
      guard let pressure = self.viewModel?.pressure else { return }
      guard let windDeg = self.viewModel?.windDeg else { return }
      guard let windSpeed = self.viewModel?.windSpeed else { return }
      guard let humidity = self.viewModel?.humidity else { return }
      guard let temp = self.viewModel?.temp else { return }
      guard let name = self.viewModel?.cityName else { return }
      guard let description = self.viewModel?.description else { return }
      guard let icon = self.viewModel?.icon else { return }
      print(name, pressure, windDeg, windSpeed, humidity, temp, icon)
      self.title = name
      self.degreesCelsiusLabel.text = "\(temp)" // 23
      self.degreesCelsiusSymbolLabel.text = "\u{2103}"
      self.pressureView.configure(title: "PRESSURE", description: "\(pressure) mm Hg") //763.53 mm Hg
      self.windView.configure(title: "WIND", description: "\(windDeg) \(windSpeed) m/s") //N 3 m/s
      self.humidityView.configure(title: "HUMIDITY", description: "\(humidity)%")//58%
      self.imageView.image = UIImage(named: description)
      self.iconView.configure(image: icon, title: description)
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
      make.width.equalTo(158)
      make.height.equalTo(143)
    }
    
    degreesCelsiusLabel.textColor = UIColor(red: 0.207, green: 0.207, blue: 0.207, alpha: 1)
    degreesCelsiusLabel.font = .boldSystemFont(ofSize: 120)
//    degreesCelsiusLabel.text = "23"
  }
  
  private func setupDegreesCelsiusSymbolLabel() {
    view.addSubview(degreesCelsiusSymbolLabel)
    degreesCelsiusSymbolLabel.snp.makeConstraints { make in
      make.leading.equalTo(degreesCelsiusLabel.snp.trailing).offset(-15)
      make.top.equalTo(degreesCelsiusLabel.snp.top)
      make.height.width.equalTo(100)
    }
    degreesCelsiusSymbolLabel.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
    degreesCelsiusSymbolLabel.font = .systemFont(ofSize: 40)
//    degreesCelsiusSymbolLabel.text = "\u{2103}"
   
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
    
//    pressureView.configure(title: "PRESSURE", description: "763.53 mm Hg")
  }
  
  private func setupWindView() {
    view.addSubview(windView)
    windView.snp.makeConstraints { make in
      make.bottom.equalTo(pressureView.snp.top).offset(-40)
      make.leading.equalToSuperview().offset(15)
      make.width.equalTo(140)
      make.height.equalTo(50)
    }
    
//    windView.configure(title: "WIND", description: "N 3 m/s")
  }
  
  private func setupHumidityView() {
    view.addSubview(humidityView)
    humidityView.snp.makeConstraints { make in
      make.bottom.equalTo(windView.snp.top).offset(-40)
      make.leading.equalToSuperview().offset(15)
      make.width.equalTo(140)
      make.height.equalTo(50)
    }
    
//    humidityView.configure(title: "HUMIDITY", description: "58%")
  }
  
  private func setupImageView() {
    view.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.bottom.trailing.equalToSuperview()
      make.width.equalTo(240)
      make.height.equalTo(576)
    }

    imageView.contentMode = .bottomRight
//    imageView.backgroundColor = .red
//    imageView.image = UIImage(named: "Rain")
    let mask = CALayer()
    mask.contents = UIImage(named: "Mask")?.cgImage
    mask.frame = CGRect(x: 0, y: 0, width: 240, height: 576)
    imageView.layer.mask = mask
    imageView.layer.masksToBounds = true
  }

}
