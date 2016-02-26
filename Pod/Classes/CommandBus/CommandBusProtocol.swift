//
//  CommandBusProtocol.swift
//  Pods
//
//  Created by Bartel on 20.02.16.
//
//

import Foundation

public protocol CommandBusProtocol {
    
    func isResponsible(command: Any!) -> Bool
    func process<ResultType>(command: Any!, completion: ((result: ResultType?, error: ErrorType?) -> Void)?) throws
    func process(command: Any!) throws
    func isInStrictMode() -> Bool
    func setStrictMode(isInStrictMode: Bool)
    
    func addHandler(handler:CommandHandlerProtocol)
    func removeHandler(handler:CommandHandlerProtocol)
    
   
}

public extension CommandBusProtocol{

    public  func process(command: Any!) throws{
        try self.process(command) { (myResult : AnyObject?, myError: ErrorType?) -> Void in}
    }

}