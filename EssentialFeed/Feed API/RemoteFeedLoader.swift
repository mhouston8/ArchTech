//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Matthew Houston on 10/30/22.
//

import Foundation


public protocol HTTPClient {
    func get(from url: URL, completionHandler: @escaping (Error?, HTTPURLResponse?) -> Void)
}

final public class RemoteFeedLoader {
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completionHandler: @escaping (Error) -> Void) {
        client.get(from: url) { error, response in
            
            if response != nil {
                completionHandler(.invalidData)
            } else {
                completionHandler(.connectivity)
            }
        }
    }
}
