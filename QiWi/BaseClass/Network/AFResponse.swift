//
//  AFResponse.swift
//  QiWi
//
//  Created by stevie on 2019/3/18.
//  Copyright © 2019 IQQL. All rights reserved.
//

import Foundation
public final class AFResponse{
    public let statusCode: Int
    public let data: Data
    public let request: URLRequest?
    public let response: URLResponse?

    
    /// Initialize a new `Response`.
    public init(statusCode: Int, data: Data, request: URLRequest? = nil, response: URLResponse? = nil) {
        self.statusCode = statusCode
        self.data = data
        self.request = request
        self.response = response
    }
    
    /// A text description of the `Response`.
    public var description: String {
        return "Status Code: \(statusCode), Data Length: \(data.count)"
    }
    
    /// A text description of the `Response`. Suitable for debugging.
    public var debugDescription: String {
        return description
    }
}
