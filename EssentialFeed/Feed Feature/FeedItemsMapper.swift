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
        
        var feed: [FeedItem] {
            return items.map({ $0.item })
        }
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
    
    //making this static also prevents us from having to call self on the RemoteFeedLoader which could cause a memor leak.
    internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemoteFeedLoader.Result {
        guard response.statusCode == OK_200,
            let root = try? JSONDecoder().decode(Root.self, from: data) else {
                return .failure(RemoteFeedLoader.Error.invalidData)
        }
        
        return .success(root.feed)
    }
}
