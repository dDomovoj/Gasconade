//
//  GCWebViewController.swift
//  PSGOneApp
//
//  Created by Sergey Dikovitsky on 7/13/17.
//  Copyright © 2017 Netcosports. All rights reserved.
//

import UIKit
import WebKit
import SafariServices
import SnapKit

protocol WebView {
  func openWebViewController(with url: URL, presenter: UIViewController)
}

public class GCWebViewController: WebViewController {
  
  override public func viewDidLoad() {
    super.viewDidLoad()
//    closeButton.isHidden = true
    setupNavigationBar()
  }

  private func setupNavigationBar() {
    let closeButton = UIButton()
    closeButton.setImage(UIImage(named: "close_button_icon_large"), for: .normal)
    closeButton.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)
    closeButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    let barButton = UIBarButtonItem(customView: closeButton)
    navigationItem.rightBarButtonItems = [barButton]
  }

  @objc private func close(_ sender: UIButton) {
    dismiss(animated: true, completion: nil)
  }
}

extension WebView {

  func openWebViewController(with url: URL, presenter: UIViewController) {
    let webViewController = SFSafariViewController(url: url)
    presenter.present(webViewController, animated: true)
  }
}
/*
 This controller is designed to be presented modally
 */
public class WebViewController: UIViewController {

  let activityIndicator = UIView()// LoaderView(style: .black)
  var isNavigationBarHidden = false

  @objc public var urlString: String? {
    didSet {
      if let urlString = urlString, let URL = URL(string: urlString) {
        webView.load(URLRequest(url: URL))
      }
    }
  }

  var barTitle: String?
  var barSubtitle: String?

  let webView = WKWebView()

  override public func updateViewConstraints() {
    super.updateViewConstraints()
    webView.snp.remakeConstraints {
//      if isNavigationBarHidden {
        $0.top.equalToSuperview()
//      } else {
//        $0.top.equalTo(navigationBarView.snp.bottom).offset(10)
//      }
      $0.leading.trailing.bottom.equalToSuperview()
    }
//    if isNavigationBarHidden {
//      closeButton.snp.remakeConstraints { (make) in
//        make.top.equalToSuperview().offset(7.0)
//        make.trailing.equalToSuperview().offset(-5.0)
//        make.width.height.equalTo(44)
//      }
//    }
//    activityIndicator.snp.remakeConstraints { (make) in
//      make.center.equalToSuperview()
//      make.width.height.equalTo(Dimens.Sizes.indicator)
//    }
  }

  override public func loadView() {
    super.loadView()
    view.backgroundColor = UIColor.blue// Colors.Application.blue
    webView.navigationDelegate = self
//    navigationBarView.isHidden = isNavigationBarHidden
//    navigationBarView.backButton.isHidden = true
//
//    closeButton.isHidden = false
//    view.addSubviews(webView, activityIndicator)
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    if let urlString = urlString, let URL = URL(string: urlString) {
//      activityIndicator.startAnimating()
      webView.load(URLRequest(url: URL))
    }

//    if let barTitle = barTitle {
//      navigationBarView.titleLabel.text = barTitle
//      navigationBarView.type = .singleTitle
//      if let barSubtitle = barSubtitle {
//        navigationBarView.subtitleLabel.text = barSubtitle
//        navigationBarView.type = .withSubtitle
//      }
//    }
  }
}

extension WebViewController: WKNavigationDelegate {

  public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) { }

  public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//    activityIndicator.stopAnimating()
  }
}
