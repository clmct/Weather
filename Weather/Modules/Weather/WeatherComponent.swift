import UIKit

extension WeatherComponent: ConfigurableProtocol {
  func configure(title: String, description: String) {
    titleLabel.text = title
    descriptionLabel.text = description
  }
}

final class WeatherComponent: UIView {
  private let titleLabel = UILabel()
  private let descriptionLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupTitleLabel()
    setupDescriptionLabel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.leading.equalToSuperview()
    }
    titleLabel.textColor = .basic4
    titleLabel.font = .basic4
  }
  
  private func setupDescriptionLabel() {
    addSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.leading.equalTo(titleLabel)
    }
    descriptionLabel.textColor = .basic4
    descriptionLabel.font = .basic5
  }
  
}