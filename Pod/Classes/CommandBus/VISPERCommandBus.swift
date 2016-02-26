//
//  VCommandBus.swift
//  Pods
//
//  Created by Jan Bartel on 25.02.16.
//
//

import Foundation

 @objc public class VISPERCommandBus: CompatibleCommandBus,IVISPERCommandBus {

    
    var _identifier = String(self)
    
    var commandHandlers = [IVISPERCommandHandler]()
    
    
    public func isResponsibleForCommand(command: NSObject) -> Bool{
        if(super.isResponsible(command)){
            return true
        }
        
        return false
    }
    
    public func identifier() -> String{
        return self._identifier
    }
    
    public func processCommand(command: NSObject, completion: ((String?, NSObject?, NSErrorPointer) -> Bool)?){
        for handler in self.commandHandlers{
            if(handler.isResponsibleForCommand(command)){
                handler.processCommand(command, completion:completion)
            }
        }
        
        super.process(command) { (result: AnyObject?, error: AnyObject?) -> Void in
            if(error != nil){
                completion?(self.identifier(),error as? NSObject,nil)
            }
        }
    }
    
    
    public override func process<ResultType>(command: Any!, completion: ((result: ResultType?, error: ErrorType?) -> Void)?) throws {
        
        try super.process(command, completion: completion)
        
        let myCompletion = completion
        
        if(command is NSObject){
            self.processCommand(command as! NSObject, completion: { (identifier: String?, myResult:NSObject?, myError: NSErrorPointer) -> Bool in
                
                if(myError != nil){
                    let realError : NSError = myError.memory!
                    myCompletion?(result: (myResult as! ResultType),error: realError)
                }else{
                    myCompletion?(result: (myResult as! ResultType),error: nil)
                }
                return true
            })
        }
    }
    
    public override func addHandler(handler: AnyObject) {
        if(handler is IVISPERCommandHandler){
            self.commandHandlers.append(handler as! IVISPERCommandHandler)
        }else if(handler is CommandHandlerProtocol){
            super.addHandler(handler)
        }else{
            fatalError("handler should conform to protocol IVISPERCommandHandler or CommandHandlerProtocol")
        }
        
    }
    
    public override func removeHandler(handler: AnyObject) {
        let index = self.commandHandlers.indexOf { (aHandler:IVISPERCommandHandler) -> Bool in
            if(aHandler === handler){
                return true
            }
            return false
        }
        
        if let anIndex = index{
            self.commandHandlers.removeAtIndex(anIndex)
        }
    }
    

}

