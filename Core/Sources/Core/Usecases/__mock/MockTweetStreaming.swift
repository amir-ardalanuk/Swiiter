#if DEBUG
//
//  File.swift
//  
//
//  Created by Amir Ardalan on 4/23/22.
//

import Foundation

public final class MockTweetStream: TweetStreaming {

    public init() {}

    public var handleResult: (() -> Result<[Tweet], Error>)?
    
    public func getStream(to keyword: String) async throws -> [Tweet] {
        sleep(3)
        if let handleResult = handleResult {
            switch handleResult() {
            case let .success(values):
                return values
            case let .failure(error):
                throw error
            }
        }

        return [.stub(), .stub(), .stub()]
    }
}
#endif
