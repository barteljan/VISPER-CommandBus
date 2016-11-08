//
//  IVISPERCommandBus.swift
//  Pods
//
//  Created by Jan Bartel on 26.02.16.
//
//

import Foundation

@objc public protocol IVISPERCommandBus : IVISPERCommandHandler {
    
    func addHandler(_ commandHandler: AnyObject!)
    func removeHandler(_ commandHandler: AnyObject!)
    
}
