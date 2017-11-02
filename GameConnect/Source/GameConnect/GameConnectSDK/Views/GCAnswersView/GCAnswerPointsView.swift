//
//  GCAnswerPointsView.swift
//  Liverpool_FC
//
//  Created by Sergey Dikovitsky on 5/3/16.
//  Copyright © 2016 NETCOSPORTS. All rights reserved.
//

import UIKit

class GCAnswerPointsView: BaseView {
  fileprivate var pointsLabel: UILabel!

  @objc func loadWith(_ value: Int) {
    pointsLabel.text = "+\(value)"
  }

  override func setup() {
    super.setup()

    backgroundColor = UIColor(hexString: "e2001a")
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
    pointsLabel.font = Fonts.Unica.regular.withSize(14)
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
