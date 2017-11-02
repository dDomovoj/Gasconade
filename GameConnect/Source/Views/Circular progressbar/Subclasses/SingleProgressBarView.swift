//
//  SingleProgressBarView.swift
//  Liverpool_FC
//
//  Created by Sergey Dikovitsky on 3/15/16.
//  Copyright © 2016 NETCOSPORTS. All rights reserved.
//

import UIKit
import UICountingLabel

public class SingleProgressBarView: CircularProgressBarsView {

  private var progressModel: CircularProgressBarModel { return bars[0] }
  private var emptyModel: CircularProgressBarModel { return bars[1] }

  private(set) var valueLabel: UICountingLabel!

  var progressWidth: CGFloat {
    get { return progressModel.width }
    set { progressModel.width = newValue }
  }

  var emptyWidth: CGFloat {
    get { return emptyModel.width }
    set { emptyModel.width = newValue }
  }

  var rotationAngle: CGFloat {
    get { return progressModel.offset }
    set { progressModel.offset = newValue }
  }

  var progressColor: UIColor {
    get { return progressModel.color }
    set {
      progressModel.color = newValue
      updateValueLabel()
    }
  }

  var emptyColor: UIColor {
    get { return emptyModel.color }
    set { emptyModel.color = newValue }
  }

  var isValueLabelHidden = true { didSet { updateValueLabel() } }
  var valueLabelColor: UIColor? { didSet { updateValueLabel() } }
  var valueLabelFont = UIFont.systemFont(ofSize: 14)/* Fonts.Unica.regular.withSize(14)*/ {
    didSet { updateValueLabel() }
  }

  func loadWithValue(value: CGFloat?, maxValue: CGFloat?, animated: Bool = false) {
    let value = value ?? 0
    let maxValue = maxValue ?? 1
    let duration = animated ? 0.2 : 0.0
    let progress = maxValue == 0.0 ? 0.0 : (value / maxValue)

    if animated {
      progressModel.progress = 0
      progressModel.enqueueAnimatedChanges(duration) {
        $0.progress = progress
      }
    } else {
      progressModel.progress = progress
    }

    valueLabel.countFromZeroTo(value: value, animated: animated)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    let progressModel = CircularProgressBarModel.defaultSingleBarModel()
    let emptyModel = CircularProgressBarModel.defaultSingleBarModel()
    emptyModel.progress = 1

    bars = [progressModel, emptyModel]

    setupValueLabel()
  }

  convenience init() {
    self.init(frame: .zero)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupValueLabel() {
    valueLabel = UICountingLabel()
    valueLabel.format = "%d"
    valueLabel.animationDuration = 0.6
    valueLabel.method = .easeIn
    valueLabel.backgroundColor = .clear
    valueLabel.isOpaque = false
    valueLabel.adjustsFontSizeToFitWidth = true
    valueLabel.minimumScaleFactor = 0.5

    addSubview(valueLabel)

    valueLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.left.greaterThanOrEqualTo(5)
      $0.right.lessThanOrEqualTo(-5)
    }

    updateValueLabel()
  }

  private func updateValueLabel() {
    valueLabel.isHidden     = isValueLabelHidden
    valueLabel.textColor    = valueLabelColor ?? progressModel.color
    valueLabel.font         = valueLabelFont
  }
}

// MARK: - UICountingLabel
extension UICountingLabel {
  func countFromZeroTo(value: CGFloat, animated: Bool) {
    text = "\(Int(value))"
    //let duration = value > 5 ? animationDuration : 0.3
    //countFromZeroTo(value, withDuration: animated ? duration : 0)
  }
}

// MARK: - CircularProgressBarModel
private extension CircularProgressBarModel {

  static var defaultAnimationDuration: TimeInterval = 0.7

  static func defaultSingleBarModel() -> CircularProgressBarModel {
    let bar = CircularProgressBarModel()
    bar.width = 4
    bar.startCap = .plain
    bar.endCap = .plain
    return bar
  }
}
