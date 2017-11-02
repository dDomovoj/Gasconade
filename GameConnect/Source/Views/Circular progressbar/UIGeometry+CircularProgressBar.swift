//
//  UIGeometry+CircularProgressBar.swift
//  Liverpool_FC
//
//  Created by Dmitry Duleba on 3/15/16.
//  Copyright © 2016 NETCOSPORTS. All rights reserved.
//

import UIKit
// swiftlint:disable identifier_name
func cpb_ellipsePointAt(center: CGPoint, angle: CGFloat, a: CGFloat, b: CGFloat) -> CGPoint {
  return CGPoint(
    x: center.x + a * cos(angle),
    y: center.y + b * sin(angle))
}

func cpb_circlePointAt(_ center: CGPoint, angle: CGFloat, radius: CGFloat) -> CGPoint {
  return cpb_ellipsePointAt(center: center, angle: angle, a: radius, b: radius)
}
