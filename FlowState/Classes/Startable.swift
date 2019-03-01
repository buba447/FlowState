//
//  Startable.swift
//  FlowState
//
//  Created by Brandon Withrow on 10/19/18.
//

import Foundation

public protocol Startable {
  func start()
  var nextStep: Startable? { get set }
  var identifier: String { get }
}
