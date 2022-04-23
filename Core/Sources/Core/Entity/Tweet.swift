//
//  File.swift
//  
//
//  Created by Amir Ardalan on 4/23/22.
//

import Foundation

struct TweetId: Hashable {
    let id: String
}

struct Tweet: Hashable {
    let id: TweetId
    let text: String
    let author: TweetAuthor
}
