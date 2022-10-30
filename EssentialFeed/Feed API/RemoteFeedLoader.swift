//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Matthew Houston on 10/30/22.
//

import Foundation


public protocol HTTPClient {
    func get(from url: URL)
}

final public class RemoteFeedLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    public func load() {
        client.get(from: url)
    }
}
