import UIKit

final class Animator {
  private var x: CGFloat = 0.0
  private var isAmimated = false
  private var view: UIView
  
  init(view: UIView) {
    self.view = view
  }
  
  func animate() {
    if isAmimated == false {
      UIView.animateKeyframes(withDuration: 0.5, delay: 1, options: .calculationModeCubic) {
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.40) {
          self.view.center.y -= 200
        }
        UIView.addKeyframe(withRelativeStartTime: 0.40, relativeDuration: 0.10) {
          self.view.center.y += 10
        }
      }
      isAmimated = true
      
    } else {
      view.layer.removeAllAnimations()
      UIView.animateKeyframes(withDuration: 0.3, delay: 1, options: .calculationModeCubic) {
        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.3) {
          self.view.center.y += 190
        }
      }
      isAmimated = false
    }
  }
  
}
