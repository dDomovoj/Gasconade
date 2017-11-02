//
//  GCBaseView.swift
//
//  Created by Sergey Dikovitsky on 4/20/17.
//  Copyright © 2017 Netcosports. All rights reserved.
//

import UIKit

class BaseView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup() { }
}

class GCBaseView: BaseView, Updateable {

  func update() { }
}
