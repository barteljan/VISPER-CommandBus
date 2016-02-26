//
//  CommandHandlerProtocol.swift
//  Pods
//
//  Created by Bartel on 20.02.16.
//
//

import Foundation

public protocol CommandHandlerProtocol : class{
    func isResponsible(command: Any!) -> Bool
    func process<ResultType>(command: Any!, completion: ((result: ResultType?, error: ErrorType?) -> Void)?) throws
    func process(command: Any!) throws
}

public extension CommandHandlerProtocol{
    public  func process(command: Any!) throws{
        try self.process(command) { (myResult : AnyObject?, myError: ErrorType?) -> Void in}
    }
}