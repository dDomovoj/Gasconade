//
//  GCAnswersView.swift
//  Liverpool_FC
//
//  Created by Sergey Dikovitsky on 4/5/16.
//  Copyright © 2016 NETCOSPORTS. All rights reserved.
//

import UIKit
import SwiftyTimer

// swiftlint:disable file_length line_length

// MARK: - GCAnswersViewDelegate
@objc open protocol GCAnswersViewDelegate: class {

  var questionProgressView: QuestionProgressView? { get }

  @objc optional func answersView(_ answersView: GCAnswersView, didSelectAnswers answerModels: [GCAnswerModel], onQuestion questionModel: GCQuestionModel)
  @objc optional func answersView(_ answersView: GCAnswersView, timerDidEndOnQuestion questionModel: GCQuestionModel)
}

// MARK: - GCAnswersView
@objcMembers
open class GCAnswersView: GCBaseView {

  fileprivate let answerOffset = UI.value(20)

  fileprivate enum QuestionType: Int {
    case two = 2
    case three = 3
    case four = 4
  }

  weak var delegate: GCAnswersViewDelegate?

  var selectedAnswers: [GCAnswerModel] = []
  var questionModel: GCQuestionModel! { didSet { loadWithQuestionModel() } }

  fileprivate var answers: [GCAnswerModel] { return (questionModel.answers as? [GCAnswerModel]) ?? [] }//{ return Array((questionModel.answers as! [GCAnswerModel])[0...3]) }

  fileprivate var timer: Timer?

  fileprivate var answersContainerView: UIView!

  fileprivate var answersViews = [AnswerView]()

  fileprivate func loadWithQuestionModel() {
    updateLayout()
    if questionModel.getRemainingSeconds() < 0 {
      questionModel.status = eGCQuestionStatusFinished
      delegate?.answersView?(self, timerDidEndOnQuestion: questionModel)
    } else {
      delegate?.questionProgressView?.loadWith(questionModel, animated: false)

      timer?.invalidate()
      timer = Timer.new(every: 1) {[weak self] in
        guard let strongSelf = self else { return }
        guard nil != strongSelf.superview else { strongSelf.timer?.invalidate(); return }

        if strongSelf.questionModel.getRemainingSeconds() < 0 {
          strongSelf.timer?.invalidate()
          strongSelf.delegate?.answersView?(strongSelf, timerDidEndOnQuestion: strongSelf.questionModel)
        } else {
          strongSelf.delegate?.questionProgressView?.loadWith(strongSelf.questionModel, animated: true)
        }
      }
      timer?.start()
    }

  }

  fileprivate func updateLayout() {
    answersViews.forEach { $0.removeFromSuperview() }
    answersViews = []

    for answer in answers {
      let answerView = createAnswerView()
      answerView.loadWithAnswerModel(answer, questionType: questionModel.type)
      answersViews.append(answerView)
    }

    guard let type = QuestionType(rawValue: answers.count) else { return }
    switch type {
    case .two:
      setupTwoAnswers()
    case .three:
      setupThreeAnswers()
    case .four:
      setupFourAnswers()
    }
  }

  fileprivate func setupTwoAnswers() {

    answersViews[0].snp.remakeConstraints {
      $0.left.top.right.equalToSuperview()
    }
    answersViews[1].snp.remakeConstraints {
      $0.top.equalTo(answersViews[0].snp.bottom).offset(answerOffset)
      $0.left.right.equalTo(answersViews[0])
      $0.size.equalTo(answersViews[0])
      $0.bottom.equalToSuperview()
    }
  }

  fileprivate func setupThreeAnswers() {

    answersViews[0].snp.remakeConstraints {
      $0.left.top.right.equalToSuperview()
    }
    answersViews[1].snp.remakeConstraints {
      $0.top.equalTo(answersViews[0].snp.bottom).offset(answerOffset)
      $0.left.right.equalTo(answersViews[0])
      $0.size.equalTo(answersViews[0])
    }
    answersViews[2].snp.remakeConstraints {
      $0.top.equalTo(answersViews[1].snp.bottom).offset(answerOffset)
      $0.left.right.equalTo(answersViews[0])
      $0.size.equalTo(answersViews[0])
      $0.bottom.equalToSuperview()
    }
  }

  fileprivate func setupFourAnswers() {

    answersViews[0].snp.remakeConstraints {
      $0.top.left.equalToSuperview()
    }
    answersViews[1].snp.remakeConstraints {
      $0.top.right.equalToSuperview()
      $0.left.equalTo(answersViews[0].snp.right).offset(answerOffset)
      $0.size.equalTo(answersViews[0])
    }
    answersViews[2].snp.remakeConstraints {
      $0.bottom.left.equalToSuperview()
      $0.top.equalTo(answersViews[0].snp.bottom).offset(answerOffset)
      $0.size.equalTo(answersViews[0])
    }
    answersViews[3].snp.remakeConstraints {
      $0.bottom.right.equalToSuperview()
      $0.left.equalTo(answersViews[2].snp.right).offset(answerOffset)
      $0.top.equalTo(answersViews[2])
    }
  }

  fileprivate func createAnswerView() -> AnswerView {
    let answerView = AnswerView()
    answerView.delegate = self

    answersContainerView.addSubview(answerView)

    return answerView
  }

  override func setup() {
    super.setup()

    setupAnswersContainerView()
  }

  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    guard let type = QuestionType(rawValue: answers.count), type == .three  else { return super.hitTest(point, with: event) }

    for answerView in answersViews {
      guard let path = answerView.maskPath else { continue }
      if path.contains(point) {
        return answerView
      }
    }

    return super.hitTest(point, with: event)
  }
}

// MARK: - AnswerViewDelegate
extension GCAnswersView: AnswerViewDelegate {
  fileprivate func answerViewDidSelect(_ answerView: AnswerView) {

    let shouldSelect: Bool

    if let index = selectedAnswers.index(where: { $0._id == answerView.answerModel._id }) {
      selectedAnswers.remove(at: index)
      shouldSelect = false
    } else {
      selectedAnswers.append(answerView.answerModel)
      shouldSelect = true
    }

    answerView.animateSelected(shouldSelect)
    delegate?.answersView?(self, didSelectAnswers: selectedAnswers, onQuestion: questionModel)
  }
}

// MARK: - View setup
private extension GCAnswersView {
  func setupAnswersContainerView() {
    answersContainerView = UIView()
    addSubview(answersContainerView)

    answersContainerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

}

// MARK: - AnswerViewDelegate
private protocol AnswerViewDelegate: class {
  func answerViewDidSelect(_ answerView: AnswerView)
}

// MARK: - AnswerView
private class AnswerView: BaseView {
  weak var delegate: AnswerViewDelegate?

  var containerView: UIView!
  var answerLabel: UILabel!
  var pointsLabel: UILabel!

  var maskPath: UIBezierPath?

  var answerModel: GCAnswerModel!

  func loadWithAnswerModel(_ answerModel: GCAnswerModel, questionType: eGCQuestionType) {
    self.answerModel = answerModel
    answerLabel.text = answerModel.answer

    if questionType == eGCQuestionTypePrediction {
      pointsLabel.text = l10N("gc_pts").replacingOccurrences(of: "%s", with: "\(answerModel.score)")
      pointsLabel.snp.makeConstraints {
        $0.height.greaterThanOrEqualTo(0)
      }
    } else {
      pointsLabel.text = ""
      pointsLabel.snp.makeConstraints {
        $0.height.equalTo(0)
      }
    }
  }

  func animateSelected(_ selected: Bool) {
    UIView.animate(
      withDuration: 0.4,
      animations: {
        self.backgroundColor = selected ? Colors.GameConnect.gray.color.enlightenColor() : .white
    })
  }

  func maskWithPath(_ path: UIBezierPath) {

    maskPath = path

    let mask = CAShapeLayer()
    mask.path = path.cgPath
    layer.mask = mask
  }

  @objc fileprivate func onPress(_ gesture: UILongPressGestureRecognizer) {
    switch gesture.state {
    case .began:
      animateStart()
    case .cancelled:
      animateEnd()
    case .ended:
      animateEnd()

      let point = gesture.location(in: self)

      if (bounds).contains(point) {
        delegate?.answerViewDidSelect(self)
      }
    default:
      animateEnd()
    }
  }

  @objc fileprivate func onTap(_ gesture: UITapGestureRecognizer) {
    animateBounce(0.95)
    delegate?.answerViewDidSelect(self)
  }

  fileprivate override func setup() {
    super.setup()

    layer.cornerRadius = 4
    backgroundColor = .white

    setupGestureRecognizers()
    setupContainerView()
    setupAnswerLabel()
    setupPointsLabel()

    clipsToBounds = false
    //setupShadow()
  }

  fileprivate func setupGestureRecognizers() {
    let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onPress(_:)))
    addGestureRecognizer(pressGesture)

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
    addGestureRecognizer(tapGesture)
  }

  func setupContainerView() {
    containerView = UIView()

    addSubview(containerView)

    containerView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.top.left.greaterThanOrEqualToSuperview()
      $0.bottom.right.lessThanOrEqualToSuperview()
    }
  }

  func setupAnswerLabel() {
    answerLabel = UILabel()

    answerLabel.font = Fonts.Unica.bold.withSize(18)
    answerLabel.textColor = .black
    answerLabel.textAlignment = .center
    answerLabel.adjustsFontSizeToFitWidth = true
    answerLabel.minimumScaleFactor = 0.5
    answerLabel.numberOfLines = 0
    answerLabel.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .vertical)

    containerView.addSubview(answerLabel)

    answerLabel.snp.makeConstraints {
      let offset = UI.value(10)
      $0.top.greaterThanOrEqualToSuperview().offset(offset)
      $0.left.equalToSuperview().offset(offset)
      $0.right.equalToSuperview().offset(-offset)
    }
  }

  func setupPointsLabel() {
    pointsLabel = UILabel()

    pointsLabel.font = Fonts.Unica.regular.withSize(12)
    pointsLabel.textColor = Colors.GameConnect.red.color
    pointsLabel.textAlignment = .center
    containerView.addSubview(pointsLabel)

    pointsLabel.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.bottom.equalToSuperview().offset(UI.value(-10))
      $0.top.equalTo(answerLabel.snp.bottom)
    }
  }
}

private extension AnswerView {
  var velocity: CGFloat { return 0.7 }
  var damping: CGFloat { return 0.8 }

  func animateStart(_ duration: Double = 0.3, completion: VoidClosure? = nil) {

    UIView.animate(
      withDuration: duration,
      delay: 0,
      usingSpringWithDamping: damping,
      initialSpringVelocity: velocity,
      options: [],
      animations: {
        self.transform = CGAffineTransform(scaleX: 1.04, y: 1.04)
    },
      completion: {_ in
        completion?()
    })
  }

  func animateEnd(_ duration: Double = 0.3, completion: VoidClosure? = nil) {
    UIView.animate(
      withDuration: duration,
      delay: 0,
      usingSpringWithDamping: damping,
      initialSpringVelocity: velocity,
      options: [],
      animations: {
        self.transform = CGAffineTransform.identity
    }, completion: {_ in
      completion?()
    })
  }
}

// MARK: - QuestionProgressView
class QuestionProgressView: BaseView {
  let primaryColor = UIColor.white
  var innerProgressView: SingleProgressBarView!
  var outerProgressView: SingleProgressBarView!

  func loadWith(_ questionModel: GCQuestionModel, animated: Bool) {
    let value = CGFloat(questionModel.getRemainingSeconds())
    let maxValue = CGFloat(questionModel.getInitialSeconds())

    innerProgressView.loadWithValue(value: value, maxValue: maxValue, animated: animated)
    outerProgressView.loadWithValue(value: value, maxValue: maxValue, animated: animated)
  }

  override func setup() {
    super.setup()

    setupInnerProgressView()
    setupOuterProgressView()
  }

  func setupInnerProgressView() {
    innerProgressView = SingleProgressBarView()
    innerProgressView.backgroundColor = .clear
    innerProgressView.isValueLabelHidden = false
    innerProgressView.valueLabelColor = primaryColor

    innerProgressView.progressColor = Colors.GameConnect.red.color
    innerProgressView.emptyColor = primaryColor

    let width: CGFloat = 2

    innerProgressView.progressWidth = width
    innerProgressView.emptyWidth = width

    addSubview(innerProgressView)

    innerProgressView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalTo(self).multipliedBy(0.7)
    }
  }

  func setupOuterProgressView() {
    outerProgressView = SingleProgressBarView()
    outerProgressView.backgroundColor = .clear
    outerProgressView.isValueLabelHidden = true

    outerProgressView.progressColor = Colors.GameConnect.gray.color
    outerProgressView.emptyColor = .clear

    let width: CGFloat = 1

    outerProgressView.progressWidth = width
    outerProgressView.emptyWidth = width

    addSubview(outerProgressView)

    outerProgressView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

// MARK: - UIView extension
private extension UIView {
  func setupShadow() {
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.2
    layer.shadowOffset = CGSize(width: 0.2, height: 0.2)
  }
}

extension UIColor {

  class var enlightenValue: CGFloat { return 0.750 }
  class var endarkenValue: CGFloat { return 0.500 }

  func enlightenColor(_ lightness: CGFloat = enlightenValue) -> UIColor {
    let value = lightness.clamp(0.0, 1.0)
    var hue: CGFloat = 0.0
    var saturation: CGFloat = 0.0
    var brightness: CGFloat = 0.0
    var alpha: CGFloat = 0.0

    getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    brightness += value * (1.0 - brightness)
    saturation -= value * saturation

    return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
  }

  func endarkenColor(_ darkness: CGFloat = endarkenValue) -> UIColor {
    let value = darkness.clamp(0.0, 1.0)
    var hue: CGFloat = 0.0
    var saturation: CGFloat = 0.0
    var brightness: CGFloat = 0.0
    var alpha: CGFloat = 0.0

    getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    brightness -= value * brightness

    return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
  }
}

extension UIView {
  func animateBounce(_ bounceCoef: CGFloat = 1.0) {
    let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
    bounceAnimation.values = [1.0, 1.2 * bounceCoef, 0.9 / bounceCoef, 1.05 * bounceCoef, 1.0]
    bounceAnimation.duration = TimeInterval(0.2)
    bounceAnimation.calculationMode = kCAAnimationCubic

    layer.add(bounceAnimation, forKey: "bounceAnimation")
  }
}
