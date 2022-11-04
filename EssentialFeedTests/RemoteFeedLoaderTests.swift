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
    
    func test_load_clientDeliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithError: .connectivity) {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWithError: .invalidData) {
                client.complete(withStatusCode: code, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponsWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWithError: .invalidData) {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load { result in
            capturedResults.append(result)
        }
        
        let emptyListJSON = Data("{\"items\": []}".utf8)
        client.complete(withStatusCode: 200, data: emptyListJSON)

        XCTAssertEqual(capturedResults, [.success([])])

    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWithError error: RemoteFeedLoader.Error, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        var capturedResults = [RemoteFeedLoader.Result]()
        sut.load { result in
            capturedResults.append(result)
        }
        
        action()
        
        XCTAssertEqual(capturedResults, [.failure(error)], file: file, line: line) //last 2 params ensure that the failure line will happen in the test_load_deliversErrorOn200HTTPResponsWithInvalidJSON() function
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
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            
            let response = HTTPURLResponse(url: requestedURLS[index], statusCode: code, httpVersion: nil, headerFields: nil)
            
            messages[index].completion(.success(data, response!))
            
        }
        
    }
    
    //Factory method to prevent duplication
    private func makeSUT(url: URL = URL(string: "https://a-given-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (sut, client)
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
