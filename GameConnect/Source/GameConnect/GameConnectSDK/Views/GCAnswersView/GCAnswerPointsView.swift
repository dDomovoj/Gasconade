//
//  GCAnswerPointsView.swift
//  Liverpool_FC
//
//  Created by Sergey Dikovitsky on 5/3/16.
//  Copyright © 2016 NETCOSPORTS. All rights reserved.
//

import UIKit

public class GCAnswerPointsView: BaseView {
  fileprivate var pointsLabel: UILabel!

  @objc public func loadWith(_ value: Int) {
    pointsLabel.text = "+\(value)"
  }

  override public func setup() {
    super.setup()

    backgroundColor = UIColor.green// (hexString: "e2001a")
    layer.cornerRadius = 5

    setupPointsLabel()
  }
}

// MARK: - View setup

private extension GCAnswerPointsView {
  func setupPointsLabel() {

    pointsLabel = UILabel()

    addSubview(pointsLabel)

    pointsLabel.textColor = .white
    pointsLabel.font = UIFont.systemFont(ofSize: 14)// Fonts.Unica.regular.withSize(14)
    pointsLabel.adjustsFontSizeToFitWidth = true
    pointsLabel.minimumScaleFactor = 0.4
    pointsLabel.textAlignment = .center

    pointsLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.left.top.greaterThanOrEqualToSuperview()
      $0.bottom.right.lessThanOrEqualToSuperview()
    }
  }
}
