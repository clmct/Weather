import UIKit
import SnapKit
import MapKit

final class MapViewController: UIViewController {
  // MARK: Properties
  var viewModel: MapViewModelProtocol?
  private let searchController = UISearchController()
  private let mapView = MKMapView()
  private let locationCardView = LocationCardView()
  private let loader = UIActivityIndicatorView(style: .medium)
  private var isShowKeyboard = false
  
  // MARK: Life cicle
  override func viewDidLoad() {
    super.viewDidLoad()
    bindToViewModel()
    setupLayout()
    setupKeyboardObsrerver()
  }
  
  // MARK: Binding
  private func bindToViewModel() {
    viewModel?.didRequestShowCard = { [weak self] in
      guard let self = self else { return }
      self.showLocationCardView()
      if let coordinate = self.viewModel?.ccordinate {
        self.mapView.setCenter(coordinate, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = ""
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotation(annotation)
      }
    }
    
    viewModel?.didRequestHideCard = { [weak self] in
      guard let self = self else { return }
      self.mapView.removeAnnotations(self.mapView.annotations)
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
  
  // MARK: Actions
  private func hideLocationCardView() {
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
    if isShowKeyboard {
      showLocationCardViewOnCenter()
      return
    }
    
    if let city = viewModel?.city, let coordinate = viewModel?.coordinateString {
      locationCardView.configure(city: city, coordinate: coordinate)
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
    }
  }
  
  private func showLocationCardViewOnCenter() {
    if let city = viewModel?.city, let coordinate = viewModel?.coordinateString {
      locationCardView.configure(city: city, coordinate: coordinate)
        UIView.animate(withDuration: 0.3) {
          self.locationCardView.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(160)
          }
          self.view.layoutIfNeeded()
        }
    }
  }
  
  @objc
  private func tap(gestureRecognizer: UIGestureRecognizer) {
    let locationPoint = gestureRecognizer.location(in: mapView)
    let locationCoordinate2D = mapView.convert(locationPoint, toCoordinateFrom: mapView)
    viewModel?.requestLocationCard(coordinate: locationCoordinate2D)
  }
  
  @objc
  private func keyboardWillShow(notification: NSNotification) {
    isShowKeyboard = true
    showLocationCardViewOnCenter()
  }
  
  @objc
  private func keyboardWillHide(notification: NSNotification) {
    isShowKeyboard = false
    showLocationCardView()
  }
  
  // MARK: Keyboard
  private func setupKeyboardObsrerver() {
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }
  
  // MARK: Layout
  private func setupLayout() {
    title = "Global Weather"
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "Map", style: .plain, target: self, action: nil)
    setupNavigationItem()
    setupMapView()
    setupLocationCardView()
    setupLoader()
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
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
  }
  
  private func setupMapView() {
    view.addSubview(mapView)
    mapView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    mapView.mapType = .standard
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(gestureRecognizer:)))
    mapView.addGestureRecognizer(gestureRecognizer)
    let latitude = CLLocationDegrees(50)
    let longitude = CLLocationDegrees(10)
    let coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                              latitudinalMeters: 2000000, longitudinalMeters: 2000000)
    mapView.setRegion(coordinateRegion, animated: true)
  }
}

// MARK: UISearchResultsUpdating
extension MapViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }
    viewModel?.updateSearchResults(text: text)
  }
}
