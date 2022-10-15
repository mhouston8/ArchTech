//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Matthew Houston on 10/5/22.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

//This is the protocol/boundary
protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}

