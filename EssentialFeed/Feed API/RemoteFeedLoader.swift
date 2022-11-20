//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Matthew Houston on 10/30/22.
//

import Foundation


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
                do {
                    let items = try FeedItemsMapper.map(data, response)
                    completionHandler(.success(items))
                } catch {
                    completionHandler(.failure(.invalidData))
                }
            case .failure:
                completionHandler(.failure(.connectivity))
            }
        }
    }
}



//Very Powerful class that represents the API call
private class FeedItemsMapper {
    
    //this is the root node in the payload contract. this is very useful
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
    
    static var OK_200: Int {
        return 200
    }
    
    static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.items.map({ $0.item })
    }
}

