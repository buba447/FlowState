//
//  ContentViewController.swift
//  FlowState_Example
//
//  Created by Brandon Withrow on 10/19/18.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import UIToolBox
import FlowState

class StringEntryViewController: UIViewController {

  let results = FlowStepIntent(String.self, String.self)

  let entryLabel = UITextField()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.green.withBrightness(brightness: 0.2)
    view.addSubview(entryLabel)
    entryLabel.textColor = UIColor.white
    entryLabel.placeholder = "Enter New String"
    
    entryLabel.pinToVerticalCenter()
    entryLabel.pinToLeadingAndTrailing(constant: 24)
    
    let saveButton = UIButton(target: self, action: #selector(savePressed))
    saveButton.setTitle("Save Content", for: .normal)
    view.addSubview(saveButton)
    saveButton.pinTopToMargin(constant: 12)
    saveButton.pinToTrailing(constant: 24)
    
    /// Set the update handler on the results block.
    results.contentUpdateHandler = { [unowned self] (content) in
      self.updateContents()
    }
    
    updateContents()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    entryLabel.becomeFirstResponder()
  }
  
  @objc func savePressed() {
    results.complete(entryLabel.text)
  }
  
  func updateContents() {
    guard isViewLoaded else { return }
    entryLabel.text = results.content
  }
}
