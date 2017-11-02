//
//  GCWebViewController.swift
//  PSGOneApp
//
//  Created by Sergey Dikovitsky on 7/13/17.
//  Copyright © 2017 Netcosports. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GCWebViewController: WebViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    closeButton.isHidden = true

    setupNavigationBar()
  }

  private func setupNavigationBar() {
    let closeButton = UIButton()
    closeButton.setImage(UIImage(named: "close_button_icon_large"), for: .normal)
    closeButton.rx.tap
      .subscribe(onNext: { [weak self] in
        self?.dismiss(animated: true, completion: nil)
      })
      .disposed(by: disposeBag)
    closeButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    let barButton = UIBarButtonItem(customView: closeButton)
    navigationItem.rightBarButtonItems = [barButton]
  }
}
