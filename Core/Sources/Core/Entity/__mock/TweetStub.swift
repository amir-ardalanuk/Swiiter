#if DEBUG
//
//  File.swift
//  
//
//  Created by Amir Ardalan on 4/23/22.
//

import Foundation
extension TweetId {
    static func stub(id: String = UUID().uuidString) -> Self {
        .init(id: id)
    }
}
extension Tweet {
    static func stub(tweetId: TweetId = .stub(), text: String = "text", author: TweetAuthor = .stub()) -> Self {
        .init(id: tweetId, text: text, author: author)
    }
}

#endif
