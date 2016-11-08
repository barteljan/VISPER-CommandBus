//
//  CompatibleCommandBusProtocol.swift
//  Pods
//
//  Created by Jan Bartel on 25.02.16.
//
//

import Foundation

public protocol CompatibleCommandBusProtocol{

    // added for objective c compatibility
    func addHandler(_ handler:AnyObject)
    func removeHandler(_ handler:AnyObject)
    func process(_ command: AnyObject!, completion: ((_ result: AnyObject?, _ error: AnyObject?) -> Void)?)
    
   
    
}
