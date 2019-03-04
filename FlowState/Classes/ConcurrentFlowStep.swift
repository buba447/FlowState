//
//  ConcurrentFlowStep.swift
//  FlowState
//
//  Created by Brandon Withrow on 10/19/18.
//

import Foundation

/**
 A Flow Step that holds muliple child steps that each run concurrently.
 
 This type of step is useful for managing multiple steps that must each
 complete before the flow can continue. (Such as multiple network requests)
 
 Once each of the child steps complete, the ConcurentFlowStep will complete and the
 next step will start.
 **/
public class ConcurentFlowStep: Startable {

  public var nextStep: Startable?
  
  public let identifier: String
  
  /// Initializes a ConcurentFlowStep with a group of child steps.
  public required init(identifier: String, steps: [Startable]) {
    self.identifier = identifier
    self.steps = steps
  }
  
  public func start() {
    completeSteps = 0
    
    for var step in steps {
      /// Create a step to call when the child step completes.
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
  
  fileprivate var completeSteps: Int = 0
  
  fileprivate func completeIfNecessary() {
    if completeSteps == steps.count {
      completeSteps = 0
      finishStep()
    }
  }
  
}
