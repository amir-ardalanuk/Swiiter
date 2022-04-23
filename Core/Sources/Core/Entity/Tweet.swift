//
//  File.swift
//  
//
//  Created by Amir Ardalan on 4/23/22.
//

import Foundation

public struct TweetId: Hashable {
    public let id: String
}

public struct Tweet: Hashable {
    public let id: TweetId
    public let text: String
    public let author: TweetAuthor
}
