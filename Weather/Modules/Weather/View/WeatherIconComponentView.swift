import UIKit
import Kingfisher
import NotificationBannerSwift

final class WeatherIconComponentView: UIView {
  // MARK: Properties
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  
  // MARK: Life cycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupTitleLabel()
    setupImageView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Methods
  func configure(image: String?, title: String?) {
    guard let image = image,
          let title = title,
          let url = NetworkRouter.getImage(code: image).getURL() else {
      let banner = NotificationBanner(title: R.string.localizable.errorIconTitle(),
                                      subtitle: R.string.localizable.errorIconSubtitle(), style: .warning)
      banner.show()
      return
    }
    imageView.kf.setImage(with: url)
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
