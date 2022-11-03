//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Matthew Houston on 10/30/22.
//

import Foundation

public enum HTTPClientResult {
    case success(HTTPURLResponse)
    case failure(Error)
}


public protocol HTTPClient {
    func get(from url: URL, completionHandler: @escaping (HTTPClientResult) -> Void)
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
        client.get(from: url) { httpClientResult in
            switch httpClientResult {
            case .success:
                completionHandler(.invalidData)
            case .failure:
                completionHandler(.connectivity)
            }
        }
    }
}
