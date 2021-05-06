import Foundation

protocol ConfigurableProtocol {
  associatedtype Model
  func configure(title: Model, description: String)
}
