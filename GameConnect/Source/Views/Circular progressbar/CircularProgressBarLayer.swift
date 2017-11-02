//
//  CirculatProgressBarLayer.swift
//  Liverpool_FC
//
//  Created by Dmitry Duleba on 3/10/16.
//  Copyright © 2016 NETCOSPORTS. All rights reserved.
//

import UIKit

// swiftlint:disable class_delegate_protocol colon identifier_name weak_delegate

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

private func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

protocol CircularProgressBarLayerDelegate {

  func progressBarLayerNeedsRedrawText(_ layer: CircularProgressBarLayer)
  func progressBarLayerDidChangeZOrder(_ layer: CircularProgressBarLayer)
  func progressBar(_ layer: CircularProgressBarLayer, didEndDraw position: CGPoint,
                   center: CGPoint, radius: CGFloat, angle: CGFloat)
}

class CircularProgressBarLayer: CALayer {

  var barModel: CircularProgressBarModel? {
    didSet {
      barModel?.delegate = self
      progress = barModel?.progress ?? 0.0
      max = barModel?.max ?? 0.0
      offset = barModel?.offset ?? 0.0
      width = barModel?.width ?? 0.0
      color = (barModel?.color ?? UIColor.white).cgColor
      setNeedsDisplay()
    }
  }

  var progressBarDelegate: CircularProgressBarLayerDelegate?

  fileprivate var animated: Bool {
    return barModel?.animationDuration > 0.0
  }

  @NSManaged fileprivate var progress : CGFloat
  @NSManaged fileprivate var max      : CGFloat
  @NSManaged fileprivate var offset   : CGFloat
  @NSManaged fileprivate var width    : CGFloat
  @NSManaged fileprivate var color    : CGColor
}

// MARK: - CircularProgressBarModelDelegate

extension CircularProgressBarLayer: CircularProgressBarModelDelegate {

  func valueDidChange(_ model: CircularProgressBarModel, type: CircularProgressBarModel.Observable) {
    switch type {
    case .progress  : progress  = model.progress
    case .max       : max       = model.max
    case .offset    : offset    = model.offset
    case .width     : width     = model.width
    case .color     : color     = model.color.cgColor
    case .text, .textColor, .textFont, .textOffset:
      progressBarDelegate?.progressBarLayerNeedsRedrawText(self)
    case .zOrder    : progressBarDelegate?.progressBarLayerDidChangeZOrder(self)
    default         : break
    }
    if animated {
      setNeedsDisplay()
    } else {
      setNeedsDisplay()
    }
  }
}

// MARK: - Private

private extension CircularProgressBarLayer {

  // MARK: Draw

  func draw(_ size: CGSize, ctx: CGContext) {
    guard let barModel = barModel else { return }

    let presentationLayer = animated ? (self.presentation() ?? self) : self
    let max = presentationLayer.max
    let progress = presentationLayer.progress
    let offset = presentationLayer.offset
    let color = presentationLayer.color
    let w = presentationLayer.width

    let isRing = barModel.style == .ring
    let startCap: CircularProgressBarModel.Cap = isRing ? barModel.startCap : .plain
    let endCap: CircularProgressBarModel.Cap = isRing ? barModel.endCap : .plain

    let value = progress * max
    let x = size.width * 0.5
    let y = size.height * 0.5
    let radius = min(x, y)
    let outerRadius = radius
    let innerRadius = isRing ? Swift.max((radius - w), 0.0) : (0.0)
    let clockwise = barModel.direction == .cw
    let sign: CGFloat = clockwise ? 1.0 : -1.0
    let startAngle =    sign * 2.0 * CGFloat(Double.pi) * (0.0   + offset)
    let endAngle =      sign * 2.0 * CGFloat(Double.pi) * (value + offset)
    let center = CGPoint(x: x, y: y)

    let point_1 = cpb_circlePointAt(center, angle: startAngle, radius: outerRadius)
    let point_2 = cpb_circlePointAt(center, angle: endAngle, radius: outerRadius)
    let point_3 = cpb_circlePointAt(center, angle: endAngle, radius: innerRadius)
    let point_4 = cpb_circlePointAt(center, angle: startAngle, radius: innerRadius)

    if value > 0.0 {
      let path = CGMutablePath()
      let points = clockwise ? [point_1, point_2, point_3, point_4] : [point_2, point_1, point_4, point_3]
      let angles = clockwise ? [startAngle, endAngle] : [endAngle, startAngle]
      let caps = clockwise ? [endCap, startCap] : [startCap, endCap]
      path.move(to: points[0])
      path.addArc(center: center, radius: outerRadius, startAngle: angles[0], endAngle: angles[1], clockwise: false)
      drawCap(points[1], to: points[2], path: path, cap: caps[0])
      path.addArc(center: center, radius: innerRadius, startAngle: angles[1], endAngle: angles[0], clockwise: true)
      drawCap(points[3], to: points[0], path: path, cap: caps[1])
      path.addLine(to: points[0])

      ctx.addPath(path)
      ctx.setFillColor(color)
      ctx.drawPath(using: .fill)
    }

    progressBarDelegate?.progressBar(self, didEndDraw: point_2, center: center, radius: outerRadius, angle: endAngle)
  }

  func drawCap(_ from: CGPoint, to: CGPoint, path: CGMutablePath, cap: CircularProgressBarModel.Cap) {
    if cap == .plain {
      path.addLine(to: to)
    } else {
      let x = (from.x + to.x) * 0.5
      let y = (from.y + to.y) * 0.5
      let radius = CGFloat(sqrt(Double((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)))) * 0.5
      path.addArc(center: CGPoint(x: x, y: y), radius: radius,
                  startAngle: 0, endAngle: CGFloat(Double.pi) * 2.0, clockwise: false)
    }
  }
}

// MARK: - Core Animation

extension CircularProgressBarLayer {

  fileprivate static let animatableKeys = NSSet(array: ["progress", "max", "offset", "width", "color"])

  override class func needsDisplay(forKey key: String) -> Bool {
    if animatableKeys.contains(key) {
      return true
    }
    return super.needsDisplay(forKey: key)
  }

  override func action(forKey event: String) -> CAAction? {

    guard let presentationLayer = presentation(), (animated && type(of: self).animatableKeys.contains(event)) else {
      return super.action(forKey: event)
    }
    let animation = CABasicAnimation(keyPath: event)
    animation.duration = barModel?.animationDuration ?? 0.0
    switch event {
    case "progress":
      animation.fromValue = presentationLayer.progress
      animation.toValue = barModel?.progress
    case "max":
      animation.fromValue = presentationLayer.max
      animation.toValue = barModel?.max
    case "offset":
      animation.fromValue = presentationLayer.offset
      animation.toValue = barModel?.offset
    case "width":
      animation.fromValue = presentationLayer.width
      animation.toValue = barModel?.width
    case "color":
      animation.fromValue = presentationLayer.color
      animation.toValue = barModel?.color.cgColor
    default: break
    }
    animation.timingFunction = CAMediaTimingFunction(name: (barModel?.animationType ?? .easeInEaseOut).mediaTimingValue)
    return animation
  }

  override func display() {
    super.display()
    let size = bounds.size
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

    if let ctx = UIGraphicsGetCurrentContext() {
      draw(size, ctx: ctx)
      contents = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
    }

    UIGraphicsEndImageContext()
  }
}
