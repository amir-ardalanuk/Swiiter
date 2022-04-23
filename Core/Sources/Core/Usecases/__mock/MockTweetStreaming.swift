#if DEBUG
//
//  File.swift
//  
//
//  Created by Amir Ardalan on 4/23/22.
//

import Foundation

final class MockTweetStream: TweetStreaming {

    var handleResult: (() -> Result<[Tweet], Error>)?

    func getStream(to keyword: String) async throws -> [Tweet] {
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
