//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Matthew Houston on 10/30/22.
//

import Foundation


public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
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
    
    public enum Result: Equatable {
        case success([FeedItem])
        case failure(Error)
    }
    
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completionHandler: @escaping (Result) -> Void) {
        client.get(from: url) { httpClientResult in
            switch httpClientResult {
            case let .success(data, _):
                if let _ = try? JSONSerialization.jsonObject(with: data){
                    completionHandler(.success([]))
                } else {
                    completionHandler(.failure(.invalidData))
                }
            case .failure:
                completionHandler(.failure(.connectivity))
            }
        }
    }
}
