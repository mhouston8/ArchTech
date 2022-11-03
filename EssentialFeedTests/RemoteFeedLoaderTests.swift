//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Matthew Houston on 10/15/22.
//

import XCTest
import EssentialFeed



class RemoteFeedLoaderTests: XCTestCase {

    //Arrange, Act, Assert
    //1. Set initializer
    
    //The SUT or sytem under test is the remote feed loader
    
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURLS.isEmpty)
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
//        let client = HTTPClientSpy() //this spy is now created in the factory method to prevent duplication.
        let (sut, client) = makeSUT(url: url)
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLS, [url, url])
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
//        let client = HTTPClientSpy() //this spy is now created in the factory method to prevent duplication.
        let (sut, client) = makeSUT(url: url)
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLS, [url])
    }

    
    //MARK: Helpers
    
    //Factory method to prevent duplication
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
    func test_load_clientDeliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        var capturedErrors = [RemoteFeedLoader.Error]()
        sut.load { error in
            capturedErrors.append(error)
        }
        //OR sut.load { capturedError = $0 }
        
        let clientError = NSError(domain: "Test", code: 0)
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedErrors, [.connectivity])
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            var capturedErrors = [RemoteFeedLoader.Error]()
            sut.load { error in
                capturedErrors.append(error)
            }
            //OR sut.load { capturedError = $0 }
            
            client.complete(withStatusCode: code, at: index)
            XCTAssertEqual(capturedErrors, [.invalidData])
        }
    }
    
    private class HTTPClientSpy: HTTPClient {
        
        //computed property
        var requestedURLS : [URL] {
            return messages.map { $0.url }
        }
        
        private var messages = [(url: URL, completion:(HTTPClientResult) -> Void)]()
        
        func get(from url: URL, completionHandler: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completionHandler))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, at index: Int = 0) {
            
            let response = HTTPURLResponse(url: requestedURLS[index], statusCode: code, httpVersion: nil, headerFields: nil)
            
            messages[index].completion(.success(response!))
            
        }
    }
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //Apple code
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
