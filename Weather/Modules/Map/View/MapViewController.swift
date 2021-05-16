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
  private var keyboardHeight: CGFloat = 0
  
  // MARK: Life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    bindToViewModel()
    setupLayout()
    setupKeyboardObserver()
  }
  
  // MARK: Binding
  private func bindToViewModel() {
    viewModel?.didRequestShowCard = { [weak self] in
      guard let self = self else { return }
      guard let coordinate = self.viewModel?.coordinate else { return }
      self.setCenterAndAnnotationOnMap(coordinate: coordinate)
      self.showLocationCardView()
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
  private func setCenterAndAnnotationOnMap(coordinate: CLLocationCoordinate2D) {
    mapView.setCenter(coordinate, animated: true)
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    annotation.title = ""
    mapView.removeAnnotations(self.mapView.annotations)
    mapView.addAnnotation(annotation)
  }
  
  private func hideLocationCardView() {
    locationCardView.snp.remakeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.height.equalTo(160)
      make.bottom.equalTo(mapView.safeAreaLayoutGuide).offset(200)
    }
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  private func showLocationCardView() {
    guard let cityName = viewModel?.cityName,
          let coordinateDescription = viewModel?.coordinateDescription else { return }
    locationCardView.configure(city: cityName, coordinateDescription: coordinateDescription)
    
    if isShowKeyboard {
      showLocationCardViewOverKeyboard()
    } else {
      showLocationCardViewBelow()
    }
  }
  
  private func showLocationCardViewBelow() {
    locationCardView.snp.remakeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.height.equalTo(160)
      make.bottom.equalTo(mapView.safeAreaLayoutGuide).offset(-16)
    }
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  private func showLocationCardViewOverKeyboard() {
    locationCardView.snp.remakeConstraints { make in
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.height.equalTo(160)
      make.bottom.equalToSuperview().offset(-(keyboardHeight + 16))
    }
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  @objc
  private func tap(gestureRecognizer: UIGestureRecognizer) {
    let locationPoint = gestureRecognizer.location(in: mapView)
    let locationCoordinate2D = mapView.convert(locationPoint, toCoordinateFrom: mapView)
    viewModel?.requestShowLocationCard(coordinate: locationCoordinate2D)
  }
  
  @objc
  private func keyboardWillShow(notification: NSNotification) {
    guard isSetKeyboardHeight(notification: notification) == true else { return }
    isShowKeyboard = true
    showLocationCardView()
  }
  
  @objc
  private func keyboardWillHide(notification: NSNotification) {
    isShowKeyboard = false
    showLocationCardView()
  }
  
  private func isSetKeyboardHeight(notification: NSNotification) -> Bool {
    guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                                as? NSValue)?.cgRectValue else {
      return false
    }
    keyboardHeight = keyboardRect.size.height
    return true
  }
  
  // MARK: Keyboard
  private func setupKeyboardObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }
  
  // MARK: Layout
  private func setupLayout() {
    title = R.string.localizable.mapTitle()
    navigationItem.backBarButtonItem = UIBarButtonItem(title: R.string.localizable.mapBackItem(),
                                                       style: .plain,
                                                       target: self,
                                                       action: nil)
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
    setupDefaultRegion()
  }
  
  private func setupDefaultRegion() {
    let latitude = CLLocationDegrees(Constants.DefaultLocation.latitude)
    let longitude = CLLocationDegrees(Constants.DefaultLocation.longitude)
    let meters = CLLocationDistance(Constants.DefaultLocation.meters)
    let coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude,
                                                                             longitude: longitude),
                                              latitudinalMeters: meters,
                                              longitudinalMeters: meters)
    mapView.setRegion(coordinateRegion, animated: true)
  }
}

// MARK: UISearchResultsUpdating
extension MapViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }
    viewModel?.requestShowLocationCard(text: text)
  }
}
