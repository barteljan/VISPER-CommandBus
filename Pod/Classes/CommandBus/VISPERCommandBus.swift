//
//  VCommandBus.swift
//  Pods
//
//  Created by Jan Bartel on 25.02.16.
//
//

import Foundation

 @objc open class VISPERCommandBus: CompatibleCommandBus,IVISPERCommandBus {

    internal var _strictMode : Bool = false
    
    open func isInStrictMode() -> Bool{
        return self._strictMode
    }
    
    open func setStrictMode(_ isInStrictMode: Bool){
        self._strictMode = isInStrictMode
    }
    
    var _identifier = "VISPERCommandBus"
    
    var commandHandlers = [IVISPERCommandHandler]()
    
    
    open func isResponsibleForCommand(_ command: NSObject) -> Bool{
        if(super.isResponsible(command)){
            return true
        }
        
        return false
    }
    
    open func identifier() -> String{
        return self._identifier
    }
    
    open func processCommand(_ command: NSObject, completion: ((String?, NSObject?, NSErrorPointer) -> Bool)?){
        
        var handlerFound = false
        
        for handler in self.commandHandlers{
            if(handler.isResponsibleForCommand(command)){
                handler.processCommand(command, completion:completion)
                handlerFound = true
            }
        }
        
        super.process(command) { (result: AnyObject?, error: AnyObject?) -> Void in
            if(self.isCommandNotFoundError(error) && self.isInStrictMode() && !handlerFound){
                fatalError(String(describing: error!))
            }else if(self.isCommandNotFoundError(error) && !handlerFound){
                completion?(self.identifier(),(error as! NSObject?),nil)
            }else if(self.isCommandNotFoundError(error) && handlerFound){

            }else if(error != nil && !self.isCommandNotFoundError(error)){
                completion?(self.identifier(),(error as! NSObject?),nil)
            }else{
                completion?(self.identifier(),(result as! NSObject?),nil)
            }
        }
    }
    
    func isCommandNotFoundError(_ error: Any?) -> Bool{
        if(error != nil){
            if let nserror = error as? NSError {
                if(nserror.domain == self.CommandNotFoundErrorDomain && self.isInStrictMode()){
                    return true
                }
            }
        }
        return false
    }
    
    
    open override func process<ResultType>(_ command: Any!, completion: ((_ result: ResultType?, _ error: Error?) -> Void)?) throws {
        
        let myCompletion = completion
        var handlerFound = false
        
        do{
            try super.process(command, completion: completion)
            handlerFound = true
        }catch let anError{
            if(!self.isCommandNotFoundError(anError)){
                completion?(nil,anError)
            }
        }
        
        
        if let myCommand = command as? NSObject{
            for handler in self.commandHandlers{
                if(handler.isResponsibleForCommand(myCommand)){
                    handler.processCommand(myCommand, completion: { (identifier: String?, myResult: NSObject?, myError: NSErrorPointer?) -> Bool in
                        
                        if(myError != nil){
                            let realError : NSError = myError!!.pointee!
                            myCompletion?((myResult as! ResultType?),realError)
                        }else{
                            myCompletion?((myResult as! ResultType?),nil)
                        }
                        
                        return true
                        
                    })
                    handlerFound = true
                }
            }
        }
        
        if(!handlerFound){
            let swiftError = CommandHandlerNotFoundError(command: command)
            let nsError = self.nsErrorFor(swiftError)
            if(self.isInStrictMode()){
                fatalError(String(describing: nsError))
            }else{
                throw swiftError
            }
        }
    }
    
    open override func process(_ command: AnyObject!, completion: ((_ result: AnyObject?, _ error: AnyObject?) -> Void)?) {
        super.process(command) { (result, error) -> Void in
            if(self.isCommandNotFoundError(error) && self.isInStrictMode()){
                fatalError(String(describing: error))
            }else{
                completion?(result,error)
            }
        }
    }

    
    open override func addHandler(_ handler: AnyObject) {
        if(handler is IVISPERCommandHandler){
            self.commandHandlers.append(handler as! IVISPERCommandHandler)
        }else if(handler is CommandHandlerProtocol){
            super.addHandler(handler)
        }else{
            fatalError("handler should conform to protocol IVISPERCommandHandler or CommandHandlerProtocol")
        }
        
    }
    
    open override func removeHandler(_ handler: AnyObject) {
        let index = self.commandHandlers.index { (aHandler:IVISPERCommandHandler) -> Bool in
            if(aHandler === handler){
                return true
            }
            return false
        }
        
        if let anIndex = index{
            self.commandHandlers.remove(at: anIndex)
        }
    }
    

}

