//
//  CircularProgressBarsView.swift
//  Liverpool_FC
//
//  Created by Dmitry Duleba on 3/10/16.
//  Copyright © 2016 NETCOSPORTS. All rights reserved.
//

import UIKit

private func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

private func >= <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

class CircularProgressBarsView: UIView {

  var bars: [CircularProgressBarModel] = [] {
    didSet {
      invalidateBarViews()
      addBarViews()
    }
  }

  override var backgroundColor: UIColor? {
    set { backgroundView.backgroundColor = newValue }
    get { return backgroundView.backgroundColor }
  }

  fileprivate var backgroundView: UIView!
  fileprivate var contentView: UIView!
  fileprivate var barViews: [CircularBarView] = []

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    let size = min(bounds.width, bounds.height) - 0.5
    backgroundView.bounds = CGRect(origin: .zero, size: CGSize(width: size, height: size))
    backgroundView.center = CGPoint(x: size * 0.5, y: size * 0.5)
    backgroundView.layer.cornerRadius = size * 0.5
  }
}

// MARK: - Private

private extension CircularProgressBarsView {

  func setupView() {
    addBackgroundView()
    addContentView()
    backgroundColor = UIColor.white.withAlphaComponent(0.3)
  }

  func addBackgroundView() {
    backgroundView = UIView()
    backgroundView.isOpaque = false
    addSubview(backgroundView)
  }

  func addContentView() {
    contentView = UIView()
    contentView.isOpaque = false
    contentView.backgroundColor = .clear
    addSubview(contentView)

    contentView.snp.makeConstraints { (make) -> Void in
      make.edges.equalToSuperview()
    }
  }

  func invalidateBarViews() {
    barViews.forEach { $0.removeFromSuperview() }
    barViews.removeAll()
  }

  func addBarViews() {
    barViews = bars
      .sorted { $0.zOrder <= $1.zOrder }
      .map { CircularBarView(barModel: $0) }
    barViews.forEach {
      contentView.addSubview($0)
      $0.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
  }
}

// MARK: - CircularBarView

private class CircularBarView: UIView {

  var barLayer: CircularProgressBarLayer {
    return (self.layer as? CircularProgressBarLayer) ?? CircularProgressBarLayer()
  }
  var label: UILabel!

  var shouldRedrawTextLabel = true

  // MARK: - Init

  required init(barModel: CircularProgressBarModel) {
    super.init(frame: CGRect.zero)
    barLayer.barModel = barModel
    barLayer.progressBarDelegate = self
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Override

  override class var layerClass: AnyClass {
    return CircularProgressBarLayer.self
  }

  // MARK: - Private

  func setupView() {
    backgroundColor = .clear
    contentScaleFactor = UIScreen.main.scale
    addLabelView()
  }

  func addLabelView() {
    label = UILabel()
    label.backgroundColor = .clear
    label.textAlignment = .center
    label.isOpaque = false
    label.isHidden = true
    addSubview(label)
  }
}

// MARK: - CircularProgressBarLayerDelegate

extension CircularBarView: CircularProgressBarLayerDelegate {

  func progressBarLayerNeedsRedrawText(_ layer: CircularProgressBarLayer) {
    shouldRedrawTextLabel = true
  }

  func progressBarLayerDidChangeZOrder(_ layer: CircularProgressBarLayer) {
    guard let superview = superview else { return }
    let barViews = superview.subviews
      .flatMap { $0 as? CircularBarView }
      .sorted { $0.barLayer.barModel?.zOrder >= $1.barLayer.barModel?.zOrder }
    barViews.forEach { superview.sendSubview(toBack: $0) }
  }

  func progressBar(_ layer: CircularProgressBarLayer,
                   didEndDraw position: CGPoint, center: CGPoint, radius: CGFloat, angle: CGFloat) {
    guard let bar = layer.barModel, let text = bar.text, let font = bar.textFont else {
      label.isHidden = true
      return
    }

    if shouldRedrawTextLabel {
      label.isHidden = false
      label.text = text
      label.font = font
      label.textColor = bar.textColor ?? bar.color
      label.sizeToFit()
      shouldRedrawTextLabel = false
    }

    let textOffset = bar.textOffset
    let a = radius + textOffset + label.bounds.size.width * 0.5
    let b = radius + textOffset + label.bounds.size.height * 0.5
    let center = cpb_ellipsePointAt(center: center, angle: angle, a: a, b: b)
    label.center = center
  }
}
