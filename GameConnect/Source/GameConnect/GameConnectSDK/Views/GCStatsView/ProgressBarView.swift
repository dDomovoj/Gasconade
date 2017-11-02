//
//  ProgressBarView.swift
//  PSG_Stadium
//
//  Created by Sergey Dikovitsky on 10/7/16.
//  Copyright © 2016 Netcosports. All rights reserved.
//

import Foundation
import SnapKit

class ProgressBarView: GCBaseView {

  enum Direction {
    case left
    case right
    case top
    case bottom

    var isHorizontal: Bool { return self == .left || self == .right}
    var isVertical: Bool { return !isHorizontal }
  }

  fileprivate(set) var progressBarView: UIView!
  fileprivate(set) var backgroundBarView: UIView!

  var direction: Direction { didSet { setNeedsUpdate() } }
  var primaryColor = UIColor.white { didSet { setNeedsUpdate() } }
  var secondaryColor  = UIColor.white { didSet { setNeedsUpdate() } }

  fileprivate var percentage: CGFloat = 0.0

  required init(direction: Direction) {
    self.direction = direction
    super.init(frame: .zero)
  }

  required override init(frame: CGRect) {
    fatalError("init(frame:) has not been implemented")
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func loadWith(percentage: CGFloat, animated: Bool) {
    self.percentage = percentage

    func updateBarConstraints(percentage: CGFloat) {
      progressBarView.snp.updateConstraints { (make) -> Void in
        if direction.isHorizontal {
          make.width.equalTo(backgroundBarView.frame.width * percentage)
        } else {
          make.height.equalTo(backgroundBarView.frame.height * percentage)
        }
      }
    }

    if animated {
      updateBarConstraints(percentage: 0)
    }

    layoutIfNeeded()

    updateBarConstraints(percentage: percentage)

    UIView.animate(
      withDuration: animated ? 0.4 : 0,
      animations: {
        self.layoutIfNeeded()
    })
  }

  override func setup() {
    super.setup()
    setupBackgroundBarView()
    setupProgressBarView()
    setNeedsUpdate()
  }

  override func update() {
    super.update()
    updateColors()
    updateDirection()
  }
}

// MARK: - View setup
private extension ProgressBarView {

  func setupBackgroundBarView() {
    backgroundBarView = UIView()

    addSubview(backgroundBarView)

    backgroundBarView.snp.makeConstraints { (make) -> Void in
      make.edges.equalToSuperview()
    }
  }

  func setupProgressBarView() {
    progressBarView = UIView()
    backgroundBarView.addSubview(progressBarView)
    updateDirection()
  }

  func updateDirection() {
    progressBarView.snp.remakeConstraints { (make) -> Void in

      if direction.isHorizontal {
        make.top.bottom.equalToSuperview()
        make.width.equalTo(0)
      } else {
        make.left.right.equalToSuperview()
        make.height.equalTo(0)
      }

      switch direction {
      case .left:
        make.right.equalToSuperview()
      case .right:
        make.left.equalToSuperview()
      case .top:
        make.bottom.equalToSuperview()
      case .bottom:
        make.top.equalToSuperview()
      }
    }
    loadWith(percentage: percentage, animated: false)
  }

  func updateColors() {
    progressBarView.backgroundColor = primaryColor
    backgroundBarView.backgroundColor = secondaryColor
  }
}
