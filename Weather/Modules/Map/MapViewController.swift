import UIKit
import SnapKit
import MapKit

final class MapViewController: UIViewController {
  var viewModel: MapViewModelProtocol? = MapViewModel()
  private let searchController = UISearchController()
  private let mapView = MKMapView()
  private let locationCardView = LocationCardView()

  override func viewDidLoad() {
    super.viewDidLoad()
    bindToViewModel()
    setupView()
  }
  
  private func bindToViewModel() {
    viewModel?.didRequestShowCard = {
      self.showLocationCardView()
    }
  }
  
  private func setupView() {
    title = "Global Weather"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "Map", style: .plain, target: self, action: nil)
    setupNavigationItem()
    setupMapView()
    setupLocationCardView()
  }
  lazy var animator = Animator(view: locationCardView)
  
  private func showLocationCardView() {
    if let city = viewModel?.city, let coordinate = viewModel?.coordinateString {
      locationCardView.configure(city: city, coordinate: coordinate)
    }
    
  }
  
  private func closeLocationCardView() {
  }
  
  private func setupLocationCardView() {
    mapView.addSubview(locationCardView)
    locationCardView.backgroundColor = .white
    locationCardView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.height.equalTo(160)
      make.bottom.equalTo(mapView.safeAreaLayoutGuide).offset(-16)
    }
    
    locationCardView.didTapShowWeather = { [weak self] in
      guard let self = self else { return }
      self.viewModel?.showWeather()
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

    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(gestureRecognizer:)))
    mapView.addGestureRecognizer(gestureRecognizer)
  }
  
  @objc func tap(gestureRecognizer: UIGestureRecognizer) {
//    showLocationCardView()
    let locationPoint = gestureRecognizer.location(in: mapView)
    let locationCoordinate2D = mapView.convert(locationPoint, toCoordinateFrom: mapView)
    viewModel?.requestLocationCard(coordinate: locationCoordinate2D)
  }
}
