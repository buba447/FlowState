//
//  FlowStepResult.swift
//  FlowState
//
//  Created by Brandon Withrow on 10/19/18.
//

import Foundation

public class FlowStepResult<Content, Result> {
  
  public var content: Content?
  
  public var contentUpdateHandler: ((Content?) -> Void)?
  
  public init(_ content: Content.Type, _ results: Result.Type) { }
  
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

