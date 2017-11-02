//
//  ViewController.swift
//
//  Created by Dmitry Duleba on 11/2/17.
//  Copyright © 2017 NetcoSports. All rights reserved.
//

import UIKit
import GameConnect

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    let question = Question()
    let external = question.externalId
    let event = question.eventId
    let competition = question.id
    GCQuestionManager.getQuestion(external, forEvent: event, inCompetition: competition) { gcQuestion in
      print(gcQuestion)
    }
  }
}
