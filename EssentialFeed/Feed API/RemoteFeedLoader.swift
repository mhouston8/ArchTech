//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Matthew Houston on 10/30/22.
//

import Foundation


public protocol HTTPClient {
    func get(from url: URL, completionHandler: @escaping (Error) -> Void)
}

final public class RemoteFeedLoader {
    
    public enum Error: Swift.Error {
        case connectivity
    }
    
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load(completionHandler: @escaping (Error) -> Void = { _ in}) {
        client.get(from: url) { error in
            completionHandler(.connectivity)
        }
    }
}
