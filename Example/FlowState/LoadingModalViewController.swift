//
//  LoadingModalViewController.swift
//  FlowState_Example
//
//  Created by Brandon Withrow on 10/19/18.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIToolBox

class LoadingModalViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    let activityIndication = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    view.addSubview(activityIndication)
    activityIndication.pinToCenter()
    activityIndication.startAnimating()
    self.modalPresentationStyle = .overFullScreen
  }

}
