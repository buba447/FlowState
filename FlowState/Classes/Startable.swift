//
//  Startable.swift
//  FlowState
//
//  Created by Brandon Withrow on 10/19/18.
//

import Foundation

/// A simple protocol that defines any step in a flow.
public protocol Startable {
  
  /// Called to start the step. Once completed the step will automatically start the next step.
  func start()
  
  /// The next step of the Flow. Settable.
  var nextStep: Startable? { get set }
  
  /// A human readable Identifier for the step. Useful for debugging.
  var identifier: String { get }
}

extension Startable {
  /// Called to complete the step and start the next step.
  func finishStep() {
    if let next = nextStep {
      next.start()
    }
  }
}
