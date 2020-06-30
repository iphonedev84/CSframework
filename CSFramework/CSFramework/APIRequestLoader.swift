//
//  APIRequestLoader.swift
//  CSframework
//
//  Created by Chirag on 25/05/20.
//  Copyright © 2020 CS. All rights reserved.
//

import Foundation

public protocol APIRequest{
    
   associatedtype RequestDataType
   associatedtype ResponsetDataType
    
   func makeRequest(from data: RequestDataType) throws -> URLRequest
   func parseResponse(data: Data) throws -> ResponsetDataType
    
}


public class APIRequestLoader<T: APIRequest> {
    
    let apiRequest: T
    let urlSession: URLSession
    
    public init(apiRequest: T, urlSession: URLSession = .shared){
        self.apiRequest = apiRequest
        self.urlSession = urlSession
    }
    
    
    public func loadAPIRequest(requestData: T.RequestDataType, completionHandler:@escaping (T.ResponsetDataType?, Error?) -> Void){
        
        do{
            let urlRequest = try apiRequest.makeRequest(from: requestData)
            urlSession.dataTask(with: urlRequest){ (data,response,error) in
                guard let data = data else { return completionHandler(nil,error)}
                do {
                    let parseResponse = try self.apiRequest.parseResponse(data: data)
                    completionHandler(parseResponse,nil)
                }
                catch{
                    completionHandler(nil,error)
                }
            }.resume()
        }catch{
            completionHandler(nil,error)
        }
        
    }
}

