//
//  IVISPERCommandHandler.swift
//  Pods
//
//  Created by Jan Bartel on 26.02.16.
//
//

import Foundation

@objc public protocol IVISPERCommandHandler  {
    

    func isResponsibleForCommand(_ command: NSObject) -> Bool
    
    func identifier() -> String
    
    func processCommand(_ command: NSObject, completion: ((String?, NSObject?, NSErrorPointer) -> Bool)?)
    
    
    @objc optional func isResponsibleForCommand(_ command: NSObject,error:NSErrorPointer) -> Bool

}
