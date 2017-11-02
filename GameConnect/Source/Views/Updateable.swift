//
//  Updateable.swift
//
//  Created by Dmitry Duleba on 5/19/16.
//  Copyright © 2016 NETCOSPORTS. All rights reserved.
//

import UIKit

private class Updater: NSObject {

  private var updateables = NSMutableSet()

  @objc func update(sender: AnyObject!) {
    let candidates = updateables.allObjects
    updateables.removeAllObjects()
    candidates.forEach {
      guard !updateables.contains($0) else { return }
      ($0 as? Updateable)?.update()
    }
  }

  func addUpdateable(updateable: Updateable) {
    updateables.add(updateable)
  }
}

private var updateDisplayLink: CADisplayLink!
private var updater: Updater = {
  let updater = Updater()
  updateDisplayLink = CADisplayLink(target: updater, selector: #selector(Updater.update(sender:)))
  updateDisplayLink.add(to: RunLoop.main, forMode: .commonModes)
  return updater
}()

protocol Updateable: class {

  func update()
  func setNeedsUpdate()
}

extension Updateable {

  func setNeedsUpdate() {
    updater.addUpdateable(updateable: self)
  }
}
