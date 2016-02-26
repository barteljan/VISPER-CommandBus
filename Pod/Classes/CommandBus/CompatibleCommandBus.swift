//
//  CompatibleCommandBus.swift
//  Pods
//
//  Created by Jan Bartel on 25.02.16.
//
//

import Foundation

public class CompatibleCommandBus: CommandBus,CompatibleCommandBusProtocol {
    
    //just for objective c compatability
    public func process(command: AnyObject!, completion: ((result: AnyObject?, error: AnyObject?) -> Void)?){
        do{
            try super.process(command) { (myResult : AnyObject?, myError: ErrorType?) -> Void in
                if(myError != nil){
                    completion?(result: myResult, error: (myError as! AnyObject))
                }else{
                    completion?(result: myResult, error: nil)
                }
            }
        }catch{
            
        }
    }
    
    public func addHandler(handler:AnyObject){
        super.addHandler(handler as! CommandHandlerProtocol)
    }
    
    public func removeHandler(handler:AnyObject){
        super.removeHandler(handler as! CommandHandlerProtocol)
    }


}
