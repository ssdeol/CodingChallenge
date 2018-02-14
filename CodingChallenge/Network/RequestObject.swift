//
//  RequestObject.swift
//  CodingChallenge
//
//  Created by Sukhpreet Deol on 2/10/18.
//  Copyright © 2018 Sukhpreet Deol. All rights reserved.
//

import Foundation

/// RequestObject Protocol will be implemented in the ServiceManager class. It will have all the fields required so we could call the Service Manager class for any number of APIs without changing the ServiceManager Class itself. Any struct that implements the RequestObject can define thier own url, method - 'GET'/'POST', header and body fields and so on. This is helpful because we won't have to change the ServiceManager class to accomodate different API calls. We will be using JSONDecoder so a DecodableResponse protocol is required by this protocol.

protocol RequestObject {
    var url:URL{get}
    var method:String{get}
    var header:[[String:Any]]?{get}
    var body:[String:Any]?{get}
    
    associatedtype response:DecodableResponse
}

/// We will control the data returned in this type so keep the code clean and smooth. It will be implemented by every class/struct that implements RequestObject protocol which is required by the ServiceManager class.
protocol DecodableResponse {
    static func parse(data:Data,success:Bool)->Self?
}

/// This completeionBlock will be used to return the success, response and error so once the ServiceManager is called. The result will be returned as this completion Block.
typealias CompletetionBlock<T:RequestObject> = (_ success:Bool,_ response:T.response?,_ error:ErrorType?) -> Void
