//
//  CommandHandlerProtocol.swift
//  Pods
//
//  Created by Bartel on 20.02.16.
//
//

import Foundation

public protocol CommandHandlerProtocol : class{
    func isResponsible(_ command: Any!) -> Bool
    
    func process(_ command: Any!) throws
    func process(_ command: Any!, completion: ((_ result: Any?, _ error: Error?) -> Void)?) throws
    func process<T>(_ command: Any!, completion: ((_ result: T?, _ error: Error?) -> Void)?) throws
    
}

public extension CommandHandlerProtocol{
    
    public  func process(_ command: Any!) throws{
        try self.process(command) { (myResult : AnyObject?, myError: Error?) -> Void in}
    }
    
    public func process<T>(_ command: Any!, completion: ((_ result: T?, _ error: Error?) -> Void)?)  throws{
        
        let myCompletion = completion
        
        try self.process(command) { (result, error) -> Void in
            myCompletion?((result as! T?),error)
        }
        
    }
}
