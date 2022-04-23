//
//  File.swift
//  
//
//  Created by Amir Ardalan on 4/23/22.
//

import Foundation
import Core

public final class TweeterStreamRepository: TweetStreaming {

    public init(){}
    
    public func getStream(to keyword: String) async throws -> [Tweet] {
        return try await MockTweetStream().getStream(to: keyword)
    }


}
