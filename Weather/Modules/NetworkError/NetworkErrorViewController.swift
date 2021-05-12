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
