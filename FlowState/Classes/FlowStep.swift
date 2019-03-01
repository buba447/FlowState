//
//  FlowStep.swift
//  FlowState
//
//  Created by Brandon Withrow on 10/19/18.
//

import Foundation

public class FlowStep<Content, Result>: Startable, FlowStepResultDelegate {

  public var nextStep: Startable?
  
  public var content: Content? {
    didSet {
      contentDidUpdate()
    }
  }
  
  public var identifier: String
  
  public typealias IntentClosure = (FlowStep<Content, Result>) -> FlowStepResult<Content, Result>?
  public typealias ResultClosure = (FlowStep<Content, Result>, Result?) -> Void
  
  public init(_ contentType: Content.Type, _ resultType: Result.Type, identifier: String, _ intent: @escaping IntentClosure) {
    self.intent = intent
    self.result = nil
    self.identifier = identifier
  }
  
  public init(_ contentType: Content.Type, _ resultType: Result.Type, identifier: String, _ intent: @escaping IntentClosure, _ result: @escaping ResultClosure) {
    self.intent = intent
    self.result = result
    self.identifier = identifier
  }

  public func setResult(_ result: @escaping ResultClosure) {
    self.result = result
  }
  
  fileprivate let intent: IntentClosure
  fileprivate var result: ResultClosure?
  fileprivate weak var stepResult: FlowStepResult<Content, Result>?
  
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
    if let result = result {
      result(self, stepResult)
    }
    if let next = nextStep {
      next.start()
    }
  }
}
