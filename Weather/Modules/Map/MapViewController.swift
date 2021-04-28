import UIKit
import SnapKit
import MapKit

final class MapViewController: UIViewController {
  private let searchController = UISearchController()
  private let mapView = MKMapView()
  private let locationCardView = LocationCardView()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  private func setupView() {
    title = "Global Weather"
    setupNavigationItem()
    setupMapView()
    setupLocationCardView()
  }
  lazy var animator = Animator(view: locationCardView)
  
  private func showLocationCardVeiw() {
    animator.animate()
  }
  
  private func closeLocationCardVeiw() {
  }
  
  private func setupLocationCardView() {
    mapView.addSubview(locationCardView)
    locationCardView.backgroundColor = .white
    locationCardView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.height.equalTo(160)
      make.bottom.equalTo(mapView.safeAreaLayoutGuide).offset(210)
    }
    
  }
  
  private func setupNavigationItem() {
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
  }
    
  private func setupMapView() {
    view.addSubview(mapView)
    
    mapView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    mapView.mapType = .standard

    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(gestureReconizer:)))
    mapView.addGestureRecognizer(gestureRecognizer)
  }
  
  @objc func tap(gestureReconizer: UIGestureRecognizer) {
    showLocationCardVeiw()
  }
}
