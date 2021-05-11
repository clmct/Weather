import UIKit

final class NetworkErrorViewController: UIViewController {
  private var networkView: NetworkErrorView?
  var didRefresh: (() -> Void)?
  
  override func loadView() {
    guard let networkView = networkView else { return }
    self.view = networkView
  }
  
  convenience init(networkError: NetworkError) {
    self.init(nibName: nil, bundle: nil)
    self.networkView = NetworkErrorView(networkType: networkError)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    networkView?.didRefresh = { [weak self] in
      self?.didRefresh?()
    }
  }
}

final class NetworkErrorView: UIView {
  private let refreshButton = UIButton(type: .system)
  private let titleLabel = UILabel()
  private let descriptionLabel = UILabel()
  var didRefresh: (() -> Void)?
  
  convenience init(networkType: NetworkError, frame: CGRect) {
    self.init(frame: frame)
    setupText(networkType: networkType)
    setupLayout()
  }
  
  convenience init(networkType: NetworkError) {
    self.init()
    setupText(networkType: networkType)
    setupLayout()
  }

  @objc
  private func refreshAction() {
    didRefresh?()
  }
  
  private func setupText(networkType: NetworkError) {
    switch networkType {
    case .noInternet:
      titleLabel.text = Constants.NoInternet.title.rawValue
      let text = Constants.NoInternet.description.rawValue
      descriptionLabel.attributedText = attributedText(text: text)
    case .serverResponse:
      titleLabel.text = Constants.SomethingWentWrong.title.rawValue
      let text = Constants.SomethingWentWrong.description.rawValue
      descriptionLabel.attributedText = attributedText(text: text)
    }
  }
  
  private func setupLayout() {
    backgroundColor = .white
    setupRefreshButton()
    setupTitleLabel()
    setupDescriptionLabel()
    
    addSubview(descriptionLabel)
    descriptionLabel.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(32)
    }
    
    addSubview(refreshButton)
    refreshButton.snp.makeConstraints { make in
      make.top.equalTo(descriptionLabel.snp.bottom).offset(24)
      make.leading.trailing.equalTo(descriptionLabel)
      make.height.equalTo(44)
    }
    
    addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.bottom.equalTo(descriptionLabel.snp.top).offset(-16)
      make.leading.trailing.equalTo(descriptionLabel)
    }
    
    refreshButton.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
  }
  
  private func setupRefreshButton() {
    refreshButton.setTitle("Refresh", for: .normal)
    refreshButton.setTitleColor(.basic3, for: .normal)
    refreshButton.layer.cornerRadius = 22
    refreshButton.layer.borderWidth = 1
    refreshButton.layer.borderColor = UIColor.basic3.cgColor
  }
  
  private func setupTitleLabel() {
    titleLabel.numberOfLines = 0
    titleLabel.textColor = .basic5
    titleLabel.font = .basic3
    titleLabel.textAlignment = .center
  }
  
  private func setupDescriptionLabel() {
    descriptionLabel.numberOfLines = 0
    descriptionLabel.textColor = .basic5
    descriptionLabel.font = .basic3
    descriptionLabel.textAlignment = .center
  }
  
  private func attributedText(text: String) -> NSMutableAttributedString {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.28
    paragraphStyle.alignment = .center
    return NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
  }
}
