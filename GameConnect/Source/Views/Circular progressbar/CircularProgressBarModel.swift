//
//  CircularProgressBarModel.swift
//  Liverpool_FC
//
//  Created by Dmitry Duleba on 3/10/16.
//  Copyright © 2016 NETCOSPORTS. All rights reserved.
//

import Foundation
import UIKit

// swiftlint:disable identifier_name opening_brace colon

protocol CircularProgressBarModelDelegate: class {

  func valueDidChange(_ model: CircularProgressBarModel, type: CircularProgressBarModel.Observable)
}

class CircularProgressBarModel {

  typealias UpdateBlock = (_ model: CircularProgressBarModel) -> Void

  fileprivate struct AnimationBlock {
    var duration: TimeInterval
    var animation: UpdateBlock
  }

  enum Observable {
    case progress
    case max
    case offset
    case color
    case width
    case direction
    case cap
    case style
    case text
    case textColor
    case textOffset
    case textFont
    case zOrder
  }

  enum Direction {
    case cw
    case ccw
  }

  enum Cap {
    case plain
    case round
  }

  enum Style {
    case ring
    case pie
  }

  enum AnimationType {
    case linear
    case easeIn
    case easeOut
    case easeInEaseOut

    var mediaTimingValue: String {
      switch self {
      case .linear        : return kCAMediaTimingFunctionLinear
      case .easeIn        : return kCAMediaTimingFunctionEaseIn
      case .easeOut       : return kCAMediaTimingFunctionEaseOut
      case .easeInEaseOut : return kCAMediaTimingFunctionEaseInEaseOut
      }
    }
  }

  // MARK: - Properties

  fileprivate var animationQueue: [AnimationBlock] = []
  fileprivate var currentAnimationBlock: AnimationBlock?
  fileprivate(set) var animationDuration: Double = 0.0

  var animationType = AnimationType.easeInEaseOut

  weak var delegate: CircularProgressBarModelDelegate?

  var zOrder      : Int = 0           { didSet { delegate?.valueDidChange(self, type: .zOrder) } }
  var style       : Style = .ring     { didSet { delegate?.valueDidChange(self, type: .style) } }
  var startCap    : Cap = .round      { didSet { delegate?.valueDidChange(self, type: .cap) } }
  var endCap      : Cap = .round      { didSet { delegate?.valueDidChange(self, type: .cap) } }
  var direction   : Direction = .cw   { didSet { delegate?.valueDidChange(self, type: .direction) } }
  var text        : String?           { didSet { delegate?.valueDidChange(self, type: .text) } }
  var textFont    : UIFont?           { didSet { delegate?.valueDidChange(self, type: .textFont) } }
  var textColor   : UIColor?          { didSet { delegate?.valueDidChange(self, type: .textColor) } }
  var textOffset  : CGFloat = 20.0    { didSet { delegate?.valueDidChange(self, type: .textOffset) } }

  // MARK: Animatable

  var progress: CGFloat = 0.0 { didSet {
      progress = progress.clamp(0.0, 1.0)
      delegate?.valueDidChange(self, type: .progress)
    }
  }
  var max: CGFloat = 1.0  { didSet { max = max.clamp(0.0, 1.0)
    delegate?.valueDidChange(self, type: .max) } }
  var offset  : CGFloat = 0.75  { didSet { offset = offset.cycleClamp(0.0, 1.0)
    delegate?.valueDidChange(self, type: .offset) } }
  var color   : UIColor = .white  { didSet { delegate?.valueDidChange(self, type: .color) } }
  var width   : CGFloat = 5.0 {
    didSet {
    delegate?.valueDidChange(self, type: .width)
    } }

  // MARK: - Public

  func enqueueAnimatedChanges(_ duration: TimeInterval, update: @escaping UpdateBlock) {
    enqueueAnimationBlock(AnimationBlock(duration: duration, animation: update))
  }
}

private extension CircularProgressBarModel {

  func enqueueAnimationBlock(_ animationBlock: AnimationBlock) {
    animationQueue.append(animationBlock)
    dequeueNextAnimationBlockIfNeeded()
  }

  func dequeueNextAnimationBlockIfNeeded() {
    if currentAnimationBlock != nil { return }
    if animationQueue.count == 0 { return }

    currentAnimationBlock = animationQueue[0]
    animationQueue = Array(animationQueue.dropFirst())
    execute(currentAnimationBlock!) { [weak self] in
      guard let selfStrong = self else { return }
      selfStrong.animationDuration = 0.0
      selfStrong.currentAnimationBlock = nil
      selfStrong.dequeueNextAnimationBlockIfNeeded()
    }
  }

  func execute(_ animationBlock: AnimationBlock, completion: @escaping () -> Void) {
    animationDuration = animationBlock.duration
    DispatchQueue.main.async {
      animationBlock.animation(self)
      DispatchQueue.main.asyncAfter(deadline: .now() + animationBlock.duration) {
        completion()
      }
    }
  }
}

extension CGFloat {

  func clamp(_ min: CGFloat, _ max: CGFloat) -> CGFloat {
    return fmin(fmax(self, min), max)
  }

  func cycleClamp(_ min: CGFloat, _ max: CGFloat) -> CGFloat {
    if self >= min && self <= max { return self }
    let range = max - min
    let value = self.truncatingRemainder(dividingBy: range)
    if value < min { return value + range }
    if value > max { return value - range }
    return value
  }
}
