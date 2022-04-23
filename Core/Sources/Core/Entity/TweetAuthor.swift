//
//  File.swift
//  
//
//  Created by Amir Ardalan on 4/23/22.
//

import Foundation

public struct AuthorId: Hashable {
    public let id: String
}

public struct TweetAuthor: Hashable {
    public let id: AuthorId
    public let userName: String?
    public let profilePicture: URL?
}
