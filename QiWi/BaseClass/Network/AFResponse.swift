//
//  AFResponse.swift
//  QiWi
//
//  Created by stevie on 2019/3/18.
//  Copyright © 2019 IQQL. All rights reserved.
//

import Foundation
public final class AFResponse:Equatable{
    public let code: Int
    public let data: Data
    public let desc: String
    public let request: URLRequest?
    public let response: URLResponse?

    
    /// Initialize a new `Response`.
    public init(statusCode: Int, data: Data, request: URLRequest? = nil, response: URLResponse? = nil) {
        self.code = statusCode
        self.data = data
        self.request = request
        self.response = response
        if()
    }
    
    
    /// A text description of the `Response`. Suitable for debugging.
    public var debugDescription: String {
        return "Code Status: \(code) \n Description:\(desc)"
    }
    
    public static func == (lhs: AFResponse, rhs: AFResponse) -> Bool {
        return lhs.code == rhs.code
            && lhs.data == rhs.data
            && lhs.response == rhs.response
    }
}
