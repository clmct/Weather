import UIKit
import Kingfisher
import NotificationBannerSwift

final class WeatherIconComponent: UIView {
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupTitleLabel()
    setupImageView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Methods
  func configure(image: String, title: String) {
    if let url = URL(string: "http://openweathermap.org/img/wn/\(image)@2x.png") {
      imageView.kf.setImage(with: url)
    } else {
      let banner = NotificationBanner(title: "Icon", subtitle: "Icon hadn't loaded", style: .warning)
      banner.show()
    }
    titleLabel.text = title
  }
  
  // MARK: Layout
  private func setupImageView() {
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.bottom.equalTo(titleLabel.snp.top)
      make.centerX.equalToSuperview()
      make.width.equalTo(100)
      make.height.equalTo(100)
    }
    imageView.contentMode = .scaleAspectFit
  }
  
  private func setupTitleLabel() {
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.bottom.equalToSuperview()
      make.centerX.equalToSuperview()
      make.leading.trailing.equalToSuperview()
    }
    titleLabel.textAlignment = .center
    titleLabel.textColor = .basic4
    titleLabel.font = .basic6
    titleLabel.numberOfLines = 2
    titleLabel.lineBreakMode = .byWordWrapping
  }
}
