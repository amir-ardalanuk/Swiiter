//
//  File.swift
//  
//
//  Created by Amir Ardalan on 4/23/22.
//

import Foundation

struct AuthorId: Hashable {
    let id: String
}

struct TweetAuthor: Hashable {
    let id: AuthorId
    let userName: String?
    let profilePicture: URL?
}
