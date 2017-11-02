//
//  GCBaseView.swift
//
//  Created by Sergey Dikovitsky on 4/20/17.
//  Copyright © 2017 Netcosports. All rights reserved.
//

import UIKit

open class BaseView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open func setup() { }
}

open class GCBaseView: BaseView, Updateable {

  open func update() { }
}
