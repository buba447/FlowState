//
//  FlowStepResult.swift
//  FlowState
//
//  Created by Brandon Withrow on 10/19/18.
//

import Foundation

/**
 FlowStepIntent is the gate keeper and data source for a FlowStep.
 
 Every active FlowStep holds a FlowStepIntent. When the FlowStep is active it
 will not continue until the FlowStepIntent has been completed with `Result`.
 
 Additionally a FlowStepIntent hold reference to the `Content` of a flow step.
 When set the FlowStepIntent calls it's `contentUpdateHandler` with the new Content.
 This gives a conveinent way to update the content of a step that has already passed.
 
 **/
public class FlowStepIntent<Content, Result> {
  
  /// The backing Content of a FlowStep
  public fileprivate(set) var content: Content?
  
  /// A closure that is called when new content is set.
  public var contentUpdateHandler: ((Content?) -> Void)?
  
  /// Initializes a FlowStepIntent with a Content type and a Result type
  public init(_ contentType: Content.Type, _ resultType: Result.Type) { }
  
  /// Called with the result of the FlowStep, if any. When called the parent FlowStep is completed.
  public func complete(_ stepResult: Result?) {
    result = stepResult
    /// Differ completion in the case that `Complete` is called before the step has returned.
    shouldDifferCompletion = delegate == nil
    delegate?.flowStepDidComplete(result: stepResult)
  }
  
  fileprivate var result: Result?
  fileprivate var shouldDifferCompletion: Bool = false
  
  weak var delegate: FlowStepResultDelegate? {
    didSet {
      if shouldDifferCompletion {
        delegate?.flowStepDidComplete(result: result)
        shouldDifferCompletion = false
      }
    }
  }
  
  func setContent(_ content: Content?) {
    self.content = content
    if let handler = contentUpdateHandler {
      handler(content)
    }
  }
}


protocol FlowStepResultDelegate: class {
  func flowStepDidComplete(result: Any?)
}

