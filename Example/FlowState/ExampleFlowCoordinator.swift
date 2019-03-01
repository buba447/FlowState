//
//  ExampleFlowCoordinator.swift
//  FlowState_Example
//
//  Created by Brandon Withrow on 3/1/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import FlowState

class ExampleFlowCoordinator: NavigationFlowCoordinator {
  
  init() {
    /// Create a navigation controller for the flow.
    let navigationController = UINavigationController()
    
    /// Create a FlowStep that displays the initial view controller
    let displayStep = FlowStep(String.self, DisplayStringAction.self, identifier: "Display", { (step) in
      /// Make a new String Display VC
      let vc = DisplayStringViewController()
      navigationController.setViewControllers([vc], animated: false)
      return vc.results
    })
    
    /// Create a step that simulates a network call to download the string from the internet.
    let fakeNetworkStep = FlowStep(String.self, String.self, identifier: "Fake Network", { (step) in
      
      /// Show a loader Vie Controller
      let loader = LoadingModalViewController()
      navigationController.present(loader, animated: true, completion: nil)
      
      /// Create step results for this step.
      let stepResults = FlowStepResult(String.self, String.self)
      /// Fake an async network call
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        /// After the 'download' has completed, call completion with the results.
        stepResults.complete("Hello, I am a new string downloaded from the internet.")
      }
      return stepResults
    }) { [unowned displayStep] (step, results) in
      /// Set the content on the display step.
      displayStep.content = results
      /// Dismiss the modal.
      navigationController.dismiss(animated: true, completion: nil)
    }
    
    let editTextStep = FlowStep(String.self, String.self, identifier: "Edit String", { (step) in
      let vc = StringEntryViewController()
      navigationController.pushViewController(vc, animated: true)
      return vc.results
    }) { [unowned displayStep] (step, results) in
      displayStep.content = results
      navigationController.popViewController(animated: true)
    }
    
    /// Set the display step completion block to switch between its results
    displayStep.setResult { (step, action) in
      guard let action = action else { return }
      switch action {
      case .editString:
        /// Edit string was pressed.
        editTextStep.content = step.content
        step.nextStep = editTextStep
      case .downloadString:
        /// Download string was pressed.
        step.nextStep = fakeNetworkStep
      }
    }
    
    super.init(navigationController: navigationController, identifier: "String Flow", firstStep: displayStep)
  }
  
  required init(navigationController: UINavigationController, identifier: String, firstStep: Startable) {
    fatalError("init(navigationController:identifier:firstStep:) has not been implemented")
  }
}
