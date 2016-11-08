//
//  CompatibleCommandBus.swift
//  Pods
//
//  Created by Jan Bartel on 25.02.16.
//
//

import Foundation


open class CompatibleCommandBus: CommandBus,CompatibleCommandBusProtocol {
    
    let CommandNotFoundErrorDomain = "CommandNotFoundErrorDomain"
    
    //just for objective c compatability
    open func process(_ command: AnyObject!, completion: ((_ result: AnyObject?, _ error: AnyObject?) -> Void)?){
        do{
            try super.process(command) { (myResult : AnyObject?, myError: Error?) -> Void in
                if(myError != nil){
                    completion?(myResult, (myError as! AnyObject))
                }else{
                    completion?(myResult, nil)
                }
            }
        }catch let error {
            if(error is CommandHandlerNotFoundError){
                let myError = error as! CommandHandlerNotFoundError
                let nsError = self.nsErrorFor(myError)
                completion?(nil, nsError)
            }else{
                completion?(nil, (error as AnyObject))
            }
        }
    }
    
    func nsErrorFor(_ myError:CommandHandlerNotFoundError) -> NSError{
        let userInfo : [AnyHashable: Any] = [NSLocalizedDescriptionKey : "CommandHandler for command:" + String(describing: myError.command) + " not found!"]
        let nsError = NSError(domain: self.CommandNotFoundErrorDomain, code: 2, userInfo: userInfo)
        return nsError
    }
    
    open func addHandler(_ handler:AnyObject){
        super.addHandler(handler as! CommandHandlerProtocol)
    }
    
    open func removeHandler(_ handler:AnyObject){
        super.removeHandler(handler as! CommandHandlerProtocol)
    }


}
