import UIKit

final class WeatherViewController: UIViewController {
  var viewModel: WeatherViewModelProtocol?
  
  private let pressureView = WeatherComponent()
  private let windView = WeatherComponent()
  private let humidityView = WeatherComponent()
  private let iconView = WeatherIconComponent()
  private let degreesCelsiusLabel = UILabel()
  private let degreesCelsiusSymbolLabel = UILabel()
  
  private let imageView = UIImageView()
  private let mask = UIImage()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Milan"
    setupLayout()
    iconView.configure(image: "", title: "Broken Clouds")
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
    degreesCelsiusLabel.text = "23"
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
    degreesCelsiusSymbolLabel.text = "\u{2103}"
   
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
    
    pressureView.configure(title: "PRESSURE", description: "763.53 mm Hg")
  }
  
  private func setupWindView() {
    view.addSubview(windView)
    windView.snp.makeConstraints { make in
      make.bottom.equalTo(pressureView.snp.top).offset(-40)
      make.leading.equalToSuperview().offset(15)
      make.width.equalTo(140)
      make.height.equalTo(50)
    }
    
    windView.configure(title: "WIND", description: "N 3 m/s")
  }
  
  private func setupHumidityView() {
    view.addSubview(humidityView)
    humidityView.snp.makeConstraints { make in
      make.bottom.equalTo(windView.snp.top).offset(-40)
      make.leading.equalToSuperview().offset(15)
      make.width.equalTo(140)
      make.height.equalTo(50)
    }
    
    humidityView.configure(title: "HUMIDITY", description: "58%")
  }
  
  private func setupImageView() {
    view.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.bottom.trailing.equalToSuperview()
      make.width.equalTo(240)
      make.height.equalTo(576)
    }

    imageView.contentMode = .bottomRight
    imageView.backgroundColor = .red
    imageView.image = UIImage(named: "Rain")
    let mask = CALayer()
    mask.contents = UIImage(named: "Mask")?.cgImage
    mask.frame = CGRect(x: 0, y: 0, width: 240, height: 576)
    imageView.layer.mask = mask
    imageView.layer.masksToBounds = true
  }

}
