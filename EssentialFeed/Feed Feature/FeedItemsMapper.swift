//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Matthew Houston on 11/20/22.
//

import Foundation

//Very Powerful class that represents the API call
//This class is internal because it should only be accessible to this module.. internal is also the default scope
//this class is not meant to be subclassed.
internal final class FeedItemsMapper {
    
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
    
    private static var OK_200: Int {
        return 200
    }
    
    internal static func map(_ data: Data, _ response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        let root = try JSONDecoder().decode(Root.self, from: data)
        return root.items.map({ $0.item })
    }
}
