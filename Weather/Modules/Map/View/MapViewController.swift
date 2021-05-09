import UIKit
import SnapKit
import MapKit

final class MapViewController: UIViewController {
  var viewModel: MapViewModelProtocol? = MapViewModel()
  private let searchController = UISearchController()
  private let mapView = MKMapView()
  private let locationCardView = LocationCardView()
  private let loader = UIActivityIndicatorView(style: .medium)
  private var isShow = true
  override func viewDidLoad() {
    super.viewDidLoad()
    bindToViewModel()
    setupView()
  }
  
  private func bindToViewModel() {
    viewModel?.didRequestShowCard = { [weak self] in
      guard let self = self else { return }
      self.showLocationCardView()
    }
    
    viewModel?.didRequestHideCard = { [weak self] in
      guard let self = self else { return }
      self.hideLocationCardView()
    }
    
    viewModel?.didRequestStart = { [weak self] in
      guard let self = self else { return }
      self.loader.startAnimating()
    }
    
    viewModel?.didRequestEnd = { [weak self] in
      guard let self = self else { return }
      self.loader.stopAnimating()
    }
  }
  
  private func setupView() {
    title = "Global Weather"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "Map", style: .plain, target: self, action: nil)
    setupNavigationItem()
    setupMapView()
    setupLocationCardView()
    setupLoader()
  }
  
  private func hideLocationCardView() {
    isShow = false
    UIView.animate(withDuration: 0.3) {
      self.locationCardView.snp.remakeConstraints { make in
        make.centerX.equalToSuperview()
        make.leading.equalToSuperview().offset(16)
        make.trailing.equalToSuperview().offset(-16)
        make.height.equalTo(160)
        make.bottom.equalTo(self.mapView.safeAreaLayoutGuide).offset(200)
      }
      self.view.layoutIfNeeded()
    }
  }
  
  private func showLocationCardView() {
    if let city = viewModel?.city, let coordinate = viewModel?.coordinateString {
      locationCardView.configure(city: city, coordinate: coordinate)
      if isShow == false {
        UIView.animate(withDuration: 0.3) {
          self.locationCardView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(160)
            make.bottom.equalTo(self.mapView.safeAreaLayoutGuide).offset(-16)
          }
          self.view.layoutIfNeeded()
        }
        isShow = true
      }
    }
  }
  
  
  private func closeLocationCardView() {
    hideLocationCardView()
  }
  
  private func setupLoader() {
    view.addSubview(loader)
    view.bringSubviewToFront(loader)
    loader.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
    }
  }
  
  private func setupLocationCardView() {
    mapView.addSubview(locationCardView)
    locationCardView.backgroundColor = .white
    locationCardView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.height.equalTo(160)
      make.bottom.equalTo(mapView.safeAreaLayoutGuide).offset(200)
    }
    
    locationCardView.didTapShowWeather = { [weak self] in
      guard let self = self else { return }
      self.viewModel?.showWeather()
    }
    
    locationCardView.didTapCloseView = { [weak self] in
      guard let self = self else { return }
      self.hideLocationCardView()
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
    let locationPoint = gestureRecognizer.location(in: mapView)
    let locationCoordinate2D = mapView.convert(locationPoint, toCoordinateFrom: mapView)
    viewModel?.requestLocationCard(coordinate: locationCoordinate2D)
  }
}
