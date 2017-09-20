//
//  CommandBus.swift
//  Pods
//
//  Created by Jan Bartel on 23.02.16.
//
//

import Foundation

public struct CommandHandlerNotFoundError: Error{
    public let command : Any!
    
}

open class CommandBus: NSObject,CommandBusProtocol {
    

    internal var handlers = [CommandHandlerProtocol]()
    
    @objc open func isResponsible(_ command: Any!) -> Bool{
       for commandHandler in self.handlers{
            if(commandHandler.isResponsible(command)){
                return true
            }
        }
        return false
    }
    
    
    open func process<ResultType>(_ command: Any!, completion: ((_ result: ResultType?, _ error: Error?) -> Void)?) throws {

        var handlerFound = false;
        
        for commandHandler in self.handlers{
            if(commandHandler.isResponsible(command)){
                try commandHandler.process(command, completion: completion)
                handlerFound = true
            }
        }
        
        if(!handlerFound){
            throw CommandHandlerNotFoundError(command: command)
        }
        
    }
    
    open func addHandler(_ handler:CommandHandlerProtocol){
        
        let contained = self.handlers.contains { (aHandler:CommandHandlerProtocol) -> Bool in
            if(handler===aHandler){
                return true
            }
            return false
        }

        if(!contained){
            self.handlers.append(handler)
        }
    }
    
   
    
    open func removeHandler(_ handler:CommandHandlerProtocol){
    
        let index = self.handlers.index { (aHandler:CommandHandlerProtocol) -> Bool in
            if(aHandler === handler){
                return true
            }
            return false
        }
        
        if let anIndex = index{
            self.handlers.remove(at: anIndex)
        }

    }
     
    
     
    
      
}
