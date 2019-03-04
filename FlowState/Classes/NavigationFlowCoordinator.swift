//
//  NavigationFlowCoordinator.swift
//  FlowState
//
//  Created by Brandon Withrow on 10/19/18.
//

import Foundation
import UIKit

/// A NavigationFlowCoordinator is a convenience class that hosts a Navigation Flow with a UINavigationController
open class NavigationFlowCoordinator: Startable {
  
  public var nextStep: Startable?
  
  public let identifier: String

  public let navigationController: UINavigationController
  
  public required init(navigationController: UINavigationController = UINavigationController(), identifier: String = "", firstStep: Startable) {
    self.navigationController = navigationController
    self.identifier = identifier
    self.firstStep = firstStep
  }
  
  public func start() {
    firstStep.start()
  }
  
  func complete() {
    if let next = nextStep {
      next.start()
    }
  }
  
  fileprivate var firstStep: Startable
}

