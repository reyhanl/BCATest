//
//  API.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

import SwiftUI

protocol APIEndpointProtocol{
    var method: HTTPMethod { get }
    
    /// Path for the endpoint.
    var path: String { get }
    
    /// Base URL for the API.
    var baseURL: String { get }
    
    /// Headers for the request.
    var headers: [String: String] { get }
    
    /// URL parameters for the request.
    var urlParams: [String: any CustomStringConvertible] { get }
    
    /// Body data for the request.
    var body: Data? { get }
    
    /// URLRequest representation of the endpoint.
    var urlRequest: URLRequest? { get }
}

enum HTTPMethod{
    case get
    case post
    
    var value: String{
        switch self {
        case .get:
            return "get"
        case .post:
            return "post"
        }
    }
}

enum APIEndpoint: APIEndpointProtocol {
    
    case getAudios(keyword: String)
    
    var method: HTTPMethod{
        switch self {
        case .getAudios:
            return .get
        }
    }
    
    var path: String{
        switch self {
        case .getAudios:
            "search"
        }
    }
    
    var baseURL: String{
        return "https://itunes.apple.com/"
    }
    
    var headers: [String : String]{
        switch self {
        case .getAudios:
            return [:]
        }
    }
    
    var urlParams: [String : any CustomStringConvertible]{
        switch self {
        case .getAudios(let keyword):
            let str = """
""
"""
            if keyword == ""{
                return ["term":str]
            }
            return ["term":keyword]
        }
    }
    
    var body: Data?{
        switch self {
        case .getAudios:
            return nil
        }
    }
    
    var urlRequest: URLRequest?{
        guard let tempURL = URL(string: baseURL + path),
              var components = URLComponents(string: tempURL.absoluteString)
        else{return nil}
        components.queryItems = urlParams.map({.init(name: $0.key, value: $0.value as? String ?? "")})
        guard let url = components.url else{return nil}
        var request = URLRequest(url: url)
        request.httpMethod = method.value
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        request.httpBody = body
        return request
    }
}
