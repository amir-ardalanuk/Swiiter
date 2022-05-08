//
//  File.swift
//  
//
//  Created by Amir Ardalan on 5/7/22.
//

import XCTest
@testable import HTTPClient

final class RequestBuilderTests: XCTestCase {

    func testRequestBuilder() {
        let url = URL.init(string: "https://api.twitter.com/2/tweets/")!
        let header = ["Authorization": "1234","Content-Type" : "application/json"]
        let urlParameter: [String: LosslessStringConvertible] =  ["query": "amir", "page": 2]
        let body: Data? = Data.init(base64Encoded: "Amir")

        let build = try? RequestBuilder(with: url, path: "search/stream/rules")
            .set(headers: header)
            .set(method: .post)
            .set(body: body)
            .set(urlParameters: urlParameter)
            .build()
        XCTAssertNotNil(build)
        for item in urlParameter {
            XCTAssertTrue(build?.url?.query?.contains("\(item.key)=\(item.value)") ?? false)
        }
        XCTAssertEqual(build?.httpMethod, "POST")
        for item in header {
            XCTAssertEqual(build?.allHTTPHeaderFields?[item.key] ?? "", item.value)
        }
        XCTAssertNotNil(build?.httpBody)
        XCTAssertEqual(build?.httpBody, body)
    }

    func testEncodableBodyApplyRequestBuilder() {
        struct Test: Codable, Hashable{
            var string = "amir"
        }

        let url = URL.init(string: "https://api.twitter.com/2/tweets/")!
        let header = ["Authorization": "1234","Content-Type" : "application/json"]
        let urlParameter: [String: LosslessStringConvertible] =  ["query": "amir", "page": 2]
        let body = Test()

        let build = try? RequestBuilder(with: url, path: "search/stream/rules")
            .set(headers: header)
            .set(method: .post)
            .set(body: body)
            .set(urlParameters: urlParameter)
            .build()
        XCTAssertNotNil(build)
        for item in urlParameter {
            XCTAssertTrue(build?.url?.query?.contains("\(item.key)=\(item.value)") ?? false)
        }
        XCTAssertEqual(build?.httpMethod, "POST")
        for item in header {
            XCTAssertEqual(build?.allHTTPHeaderFields?[item.key] ?? "", item.value)
        }
        XCTAssertNotNil(build?.httpBody)
        XCTAssertEqual(try? JSONDecoder().decode(Test.self, from: build?.httpBody ?? Data()), body)
    }
}
