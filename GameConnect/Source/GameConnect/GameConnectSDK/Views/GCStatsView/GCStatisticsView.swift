//
//  GCStatisticsView.swift
//  Liverpool_FC
//
//  Created by Sergey Dikovitsky on 5/6/16.
//  Copyright © 2016 NETCOSPORTS. All rights reserved.
//

import UIKit
import UICountingLabel

@objc protocol GCStatisticsViewDelegate: class {
  func statisticsView(_ statisticsView: GCStatisticsView, didRequestShare shareModel: GCQuestionModel)
  func statisticsViewDidTapSponsors(_ statisticsView: GCStatisticsView)
}

@objcMembers
class GCStatisticsView: GCBaseView {

  weak var delegate: GCStatisticsViewDelegate?

  fileprivate var contentView: UIView!
  fileprivate var stackView = UIStackView()
  fileprivate var answerBars = [StatisticsBarView]()
  fileprivate var sponsorsButton: UIButton!

  var isAnswerBarsHidden: Bool {
    get {
      return stackView.isHidden
    }
    set {
      stackView.isHidden = newValue
    }
  }

  var questionModel: GCQuestionModel? { didSet { update() } }

  fileprivate var answers: [GCAnswerModel] {
    guard let questionModel = questionModel else { return [] }

    return (questionModel.answers as? [GCAnswerModel]) ?? []
  }

  fileprivate var percentages: [Int] {
    guard let questionModel = questionModel else { return [] }

    var result = answers.flatMap { answer -> Int in
      let personAnswers = questionModel.calculateNumberOfPersonAnswers()
      let percentage = personAnswers > 0 ? (CGFloat(answer.total_answers) / CGFloat(personAnswers)) : 0

      return Int(round(percentage * 100))
    }

    let difference = 100 - result.reduce(0, { $0 + $1 })

    if let maxPercentage = result.max(), difference != 0 {
      if let index = result.index(of: maxPercentage) {
        result[index] += difference
      }
    }

    return result
  }

  override func update() {
    guard nil != questionModel else { return }

    setupStackView()
  }

  func animateView() {
    isAnswerBarsHidden = false
    let answerPercentages = percentages
    for i in 0..<answerBars.count {
      answerBars[i].loadWith(answerPercentages[i], answerModel: answers[i])
    }
  }

  override func setup() {
    super.setup()

    setupContentView()
  }
}

// MARK: - Actions

private extension GCStatisticsView {

  @objc func didTapSponsors() {
    delegate?.statisticsViewDidTapSponsors(self)
  }
}

// MARK: - View setup

private extension GCStatisticsView {

  func setupContentView() {
    contentView = UIView()
    contentView.backgroundColor = .clear

    addSubview(contentView)

    contentView.snp.makeConstraints {
      let inset = UI.value(18)
      $0.edges.equalToSuperview().inset(inset)
    }

    setupSponsorsImageView()
  }

  func setupSponsorsImageView() {
    sponsorsButton = UIButton()
    sponsorsButton.layer.borderWidth = 1
    sponsorsButton.layer.cornerRadius = 3
    sponsorsButton.layer.borderColor = UIColor.white.cgColor
    sponsorsButton.setTitle(l10N("gc_logo_pmu").uppercased(), for: .normal)
    sponsorsButton.titleLabel?.font = Fonts.Unica.regular.withSize(13)
    let logoImageView = UIImageView()
    logoImageView.image = UIImage(named: "gc_pmu_logo_white")
    sponsorsButton.addSubview(logoImageView)
    logoImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalTo(-10)
      $0.height.equalToSuperview().multipliedBy(0.6)
      $0.width.equalTo(logoImageView.snp.height).multipliedBy(1.86)
    }
    sponsorsButton.addTarget(self, action: #selector(didTapSponsors), for: .touchUpInside)

    contentView.addSubview(sponsorsButton)

    sponsorsButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.height.equalTo(35)
      $0.width.equalTo(243)
      $0.centerY.equalTo(contentView.snp.bottom).offset(-20)
    }
  }

  func setupStackView() {
    stackView.removeFromSuperview()

    setupAnswerBars()
    func insetSubview() -> UIView {
      let view = UIView()
      view.backgroundColor = .clear
      return view
    }
    let leadingSubviews: [UIView] = answerBars.count >= 4 ? [] : [insetSubview()]
    let trailingSubviews: [UIView] = answerBars.count >= 4 ? [] : [insetSubview()]
    let arrangedSubviews: [UIView] = leadingSubviews + (answerBars as [UIView]) + trailingSubviews
    stackView = UIStackView(arrangedSubviews: arrangedSubviews)
    stackView.distribution = .equalCentering
    stackView.axis = .horizontal
    stackView.spacing = UI.value(14)

    contentView.addSubview(stackView)

    stackView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.bottom.equalTo(sponsorsButton.snp.top).offset(-UI.value(40))
      $0.left.lessThanOrEqualToSuperview()
      $0.right.lessThanOrEqualToSuperview()
      $0.width.lessThanOrEqualTo(600)
      $0.centerX.equalToSuperview()
    }

    answerBars.forEach {
      $0.snp.remakeConstraints {
        $0.width.equalTo(UI.value(isIPad() ? 85 : 60))
        $0.height.equalTo(stackView)
      }
    }
  }

  func setupAnswerBars() {
    answerBars = []

    guard let questionModel = questionModel else { return }

    zip(answers, percentages).forEach { answer, percentage in
      let answerBar = StatisticsBarView()

      let isMyAnswer = (questionModel.getMyAnswersModel() as? [GCAnswerModel] ?? [])
        .contains(where: { $0._id == answer._id })

      answerBar.primaryColor = UIColor(hexString: isMyAnswer ? "e2001a" : "4f5e68")
      answerBar.secondaryColor = isMyAnswer ? .white : UIColor.white.endarkenColor(0.5)
      answerBar.loadWith(percentage, answerModel: answer)

      answerBars.append(answerBar)
    }
  }
}

// MARK: - StatBarView

private class StatisticsBarView: BaseView {

  fileprivate var primaryColor = UIColor.white { didSet { updateColors() } }
  fileprivate var secondaryColor = UIColor.white { didSet { updateColors() } }

  fileprivate var valueLabel: UICountingLabel!
  fileprivate var progressView: ProgressBarView!
  fileprivate var answerLabel: UILabel!

  func loadWith(_ percentage: Int, answerModel: GCAnswerModel) {
    let floatPercentage = CGFloat(percentage)
    progressView.loadWith(percentage: floatPercentage / 100, animated: true)
    valueLabel.countFromZero(to: floatPercentage)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.hyphenationFactor = 1
    paragraphStyle.alignment = .center
    let font: UIFont = Fonts.Unica.regular.withSize(14) ?? UIFont.systemFont(ofSize: 14)
    let attributedString =
      NSAttributedString(string: answerModel.answer,
                         attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle,
                                      NSAttributedStringKey.font: font])
    answerLabel.attributedText = attributedString
  }

  func updateColors() {
    progressView.primaryColor = primaryColor
    progressView.secondaryColor = .clear
    valueLabel.textColor = secondaryColor
    answerLabel.textColor = secondaryColor
  }

  fileprivate override func setup() {
    super.setup()

    setupProgressView()
    setupValueLabel()
    setupAnswerLabel()
  }

  func setupProgressView() {
    progressView = ProgressBarView(direction: .top)

    addSubview(progressView)

    progressView.snp.makeConstraints {
      $0.width.equalTo(self).multipliedBy(0.6)
      $0.top.centerX.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-UI.value(66))
    }
  }

  func setupValueLabel() {
    valueLabel = UICountingLabel()
    valueLabel.format = "%d %%"
    valueLabel.animationDuration = 0.5
    valueLabel.font = Fonts.Unica.regular.withSize(14)
    valueLabel.textAlignment = .center

    addSubview(valueLabel)

    valueLabel.snp.makeConstraints {
      $0.bottom.equalTo(progressView.progressBarView.snp.top).offset(UI.value(-5))
      $0.left.equalTo(UI.value(5))
      $0.right.equalTo(UI.value(-5))
    }
  }

  func setupAnswerLabel() {
    answerLabel = UILabel()
    answerLabel.numberOfLines = 3
    answerLabel.textColor = Colors.GameConnect.midGray.color
    answerLabel.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .vertical)

    addSubview(answerLabel)

    answerLabel.snp.makeConstraints {
      $0.left.equalTo(UI.value(-8))
      $0.right.equalTo(UI.value(8))
      $0.bottom.equalToSuperview()
    }
  }
}
