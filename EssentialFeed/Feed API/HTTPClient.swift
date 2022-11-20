//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Matthew Houston on 11/20/22.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completionHandler: @escaping (HTTPClientResult) -> Void)
}
