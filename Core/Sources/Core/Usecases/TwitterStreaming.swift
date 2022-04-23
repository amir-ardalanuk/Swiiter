//
//  File.swift
//  
//
//  Created by Amir Ardalan on 4/23/22.
//

import Foundation

protocol TweetStreaming {
    func getStream(to keyword: String) async throws -> [Tweet]
}
