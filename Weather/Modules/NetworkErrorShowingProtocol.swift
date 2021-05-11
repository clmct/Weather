import UIKit

protocol NetworkErrorShowingProtocol {}
extension NetworkErrorShowingProtocol where Self: UINavigationController {
  func showNetworkError(networkError: NetworkError, completion: @escaping () -> Void) {
    
    let networkErrorVC = NetworkErrorViewController(networkError: networkError)
    networkErrorVC.didRefresh = { [weak self] in
      self?.dismiss(animated: true, completion: nil)
      completion()
    }
    networkErrorVC.modalPresentationStyle = .fullScreen
    present(networkErrorVC, animated: true, completion: nil)
  }
}

extension NetworkErrorShowingProtocol where Self: UIViewController {
  func showNetworkError(networkError: NetworkError, completion: @escaping () -> Void) {
    
    var networkErrorView: NetworkErrorView? = NetworkErrorView(networkType: networkError, frame: view.frame)
    networkErrorView?.didRefresh = {
      networkErrorView?.removeFromSuperview()
      networkErrorView = nil
      completion()
    }
    if let networkErrorView = networkErrorView {
      view.addSubview(networkErrorView)
    }
  }
}
