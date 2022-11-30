//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Matthew Houston on 10/5/22.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

//This is the protocol/boundary
public protocol FeedLoader {
    func load(completionHandler: @escaping (LoadFeedResult) -> Void)
}
