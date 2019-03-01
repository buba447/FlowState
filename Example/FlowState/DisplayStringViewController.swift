//
//  DisplayViewController.swift
//  FlowState_Example
//
//  Created by Brandon Withrow on 10/19/18.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import UIToolBox
import FlowState

enum DisplayStringAction {
  case editString
  case downloadString
}

class DisplayStringViewController: UIViewController {
  
  /// Create a step results handler, with a defined content and result type.
  let results = FlowStepResult(String.self, DisplayStringAction.self)
  
  let stringLabel = UILabel(font: UIFont.boldSystemFont(ofSize: 28), textColor: UIColor.white)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.blue.withBrightness(brightness: 0.2)
    
    view.addSubview(stringLabel)
    stringLabel.numberOfLines = 0
    stringLabel.pinToCenter()
    stringLabel.pinToLeadingAndTrailing(constant: 24)
    
    let wrapper = UIView()
    view.addSubview(wrapper)
    wrapper.pinToBottomSafeArea(safeAreaPadding: 0, maxPadding: 24)
    wrapper.pinMinimumToLeadingAndTrailing()
    wrapper.pinToHorizontalCenter()
    
    let downloadButton = UIButton(target: self, action: #selector(downloadPressed))
    downloadButton.setTitle("Download Content", for: .normal)
    wrapper.addSubview(downloadButton)
    downloadButton.pinToTopAndBottom()
    downloadButton.pinToLeading()
    
    let editButton = UIButton(target: self, action: #selector(editStringPressed))
    editButton.setTitle("Edit Content", for: .normal)
    wrapper.addSubview(editButton)
    editButton.pinToTopAndBottom()
    editButton.pinToTrailing()
    editButton.pinLeadingToView(downloadButton, constant: 12)
    
    /// Set the update handler on the results block.
    results.contentUpdateHandler = { [unowned self] (content) in
      self.updateContent()
    }
    
    updateContent()
  }
  
  func updateContent() {
    guard isViewLoaded else { return }
    stringLabel.text = results.content?.count ?? 0 == 0 ? "No String Found!" : results.content
    stringLabel.textColor = results.content?.count ?? 0 == 0 ? UIColor.red : UIColor.white
  }
  
  @objc func downloadPressed() {
    results.complete(.downloadString)
  }
  
  @objc func editStringPressed() {
    results.complete(.editString)
  }
  
}
