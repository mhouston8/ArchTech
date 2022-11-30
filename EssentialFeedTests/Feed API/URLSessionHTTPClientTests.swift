//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Matthew Houston on 11/28/22.
//

import XCTest

class URLSessionHTTPClient {
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL) {
        session.dataTask(with: url) { _, _, _ in
            
        }
    }
    
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_createsDataTaskWithURL() {
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        
        
        sut.get(from: url)
        
        XCTAssertEqual(session.receivedURLS, [url])
    }
    
    class URLSessionSpy: URLSession {
        var receivedURLS = [URL]()
        
        
        //everytime we invoke this function, we will append the url
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLS.append(url)
            return FakeURLSessionDataTask()
        }
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {
        
    }

}
