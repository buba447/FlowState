//
//  ConcurrentFlowStep.swift
//  FlowState
//
//  Created by Brandon Withrow on 10/19/18.
//

import Foundation

public class ConcurentFlowStep: Startable {

  public let identifier: String
  
  public required init(identifier: String, steps: [Startable]) {
    self.identifier = identifier
    self.steps = steps
  }
  
  public func start() {
    completeSteps = 0
    
    for var step in steps {
      let completer = FlowStep(Any.self, Any.self, identifier: "Concurrent Completion", { [unowned self] (step) in
          self.completeSteps = self.completeSteps + 1
          return nil
      }) { [unowned self] (step, results) in
        self.completeIfNecessary()
      }
      step.nextStep = completer
    }
    
    for step in steps {
      step.start()
    }
    
  }

  fileprivate let steps: [Startable]
  public var nextStep: Startable?
  fileprivate var completeSteps: Int = 0
  
  fileprivate func completeIfNecessary() {
    if completeSteps == steps.count {
      if let next = nextStep {
        next.start()
      }
      completeSteps = 0
    }
  }
  
}
