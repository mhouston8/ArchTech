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
            case let .success(data, response):
                if response.statusCode == 200, let root = try? JSONDecoder().decode(Root.self, from: data) {
                    completionHandler(.success(root.items.map{$0.item}))
                } else {
                    completionHandler(.failure(.invalidData))
                }
            case .failure:
                completionHandler(.failure(.connectivity))
            }
        }
    }
}


//this is the root node in the payload contract
private struct Root: Decodable {
    let items: [Item]
}


//transitional representation
//this one matches the api json representation
private struct Item: Decodable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let image: URL //this is different from FeedItem model
    
    var item: FeedItem {
        return FeedItem(id: id, description: description, location: location, imageURL: image)
    }
}
