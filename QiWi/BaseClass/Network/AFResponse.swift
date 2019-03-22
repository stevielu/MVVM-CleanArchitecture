//
//  AFResponse.swift
//  QiWi
//
//  Created by stevie on 2019/3/18.
//  Copyright © 2019 IQQL. All rights reserved.
//

import Foundation
public final class AFResponse{
    public let code: Int
    public let data: Any
    public let desc: String
    public let request: URLRequest?
    public let response: URLResponse?

    
    /// Initialize a new `Response`.
    public init(statusCode: Int, data: Any, request: URLRequest? = nil, response: URLResponse? = nil) {
        self.code = statusCode
        self.data = data
        self.request = request
        self.response = response
    }
    
    
    /// A text description of the `Response`. Suitable for debugging.
    public var debugDescription: String {
        return "Code Status: \(code) \n Description:\(desc)"
    }
}
