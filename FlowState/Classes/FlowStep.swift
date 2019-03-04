//
//  FlowStep.swift
//  FlowState
//
//  Created by Brandon Withrow on 10/19/18.
//

import Foundation

/**
 FlowStep represents a single step in a flow. The FlowStep is initialized with an
 intent block that returns a FlowStepIntent. Once started the flow does not progress
 until `complete()` is called on the FlowStepIntent.
 
 A FlowStep has two generic properties, `Content` and `Results`.
 
 The `Content` should represent the content that the FlowStep displays. The Content is
 settable and will forward its information to the FlowStepIntent.
 
 The `Result` should represent the information that the FlowStep needs to collect
 in order to complete.
 
 A FlowStep has two closures, the Intent closure and the Completion closure.
 
 The Intent closure is called when the step begins and must return a FlowStepIntent.
 
 The Completion closure is called once the step has completed, and can be used to
 retrieve the resulting information and to set the next step of the flow.
 
 
 **/
public class FlowStep<Content, Result>: Startable, FlowStepResultDelegate {

  /**
  The Content that backs the Flow Step.
   If the content is set while the FlowStep is active, it will forward the content
   to the child FlowStepIntent
   **/
  public var content: Content? {
    didSet {
      contentDidUpdate()
    }
  }
  
  public var nextStep: Startable?
  
  public var identifier: String
  
  public typealias IntentClosure = (FlowStep<Content, Result>) -> FlowStepIntent<Content, Result>?
  public typealias CompletionClosure = (FlowStep<Content, Result>, Result?) -> Void
  
  /// Initialize the FlowStep with a Content type, Result type, Identifier, and an Intent closure.
  public init(_ contentType: Content.Type, _ resultType: Result.Type, identifier: String, _ intent: @escaping IntentClosure) {
    self.intent = intent
    self.completion = nil
    self.identifier = identifier
  }
  
  /// Initialize the FlowStep with a Content type, Result type, Identifier, an Intent closure, and a Comletion closure.
  public init(_ contentType: Content.Type, _ resultType: Result.Type, identifier: String, _ intent: @escaping IntentClosure, _ completion: @escaping CompletionClosure) {
    self.intent = intent
    self.completion = completion
    self.identifier = identifier
  }

  /// Set the completion closure.
  public func setCompletion(_ completion: @escaping CompletionClosure) {
    self.completion = completion
  }
  
  public func start() {
    print("STEP BEGAN: " + self.identifier)
    self.stepResult = nil
    if let stepResult = intent(self) {
      self.stepResult = stepResult
      stepResult.setContent(content)
      stepResult.delegate = self
    } else {
      complete(stepResult: nil)
    }
  }
  
  fileprivate let intent: IntentClosure
  fileprivate var completion: CompletionClosure?
  fileprivate weak var stepResult: FlowStepIntent<Content, Result>?
  
  fileprivate func contentDidUpdate() {
    stepResult?.setContent(content)
  }
  
  func flowStepDidComplete(result: Any?) {
    if let resultItem = result as? Result {
      complete(stepResult: resultItem)
    } else {
      complete(stepResult: nil)
    }
  }
  
  fileprivate func complete(stepResult: Result?) {
    print("STEP COMPLETE: " + self.identifier)
    if let completion = completion {
      completion(self, stepResult)
    }
    finishStep()
  }
}
