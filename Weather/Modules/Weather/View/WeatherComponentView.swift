import UIKit

final class WeatherComponentView: UIView {
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
  
  // MARK: Methods
  func configure(title: String, description: String) {
    titleLabel.text = title
    descriptionLabel.text = description
  }
  
  // MARK: Layout
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
