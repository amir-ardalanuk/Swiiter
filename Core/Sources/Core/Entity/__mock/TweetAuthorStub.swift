#if DEBUG
//
//  File 2.swift
//  
//
//  Created by Amir Ardalan on 4/23/22.
//
import Foundation

extension AuthorId {
    static func stub(id: String = UUID().uuidString) -> Self {
        .init(id: id)
    }
}

extension TweetAuthor {
    static func stub(authorId: AuthorId = .stub(), username: String = "username", picture: URL? = .init(string: "https://picsum.photos/200")) -> Self {
        .init(id: authorId, userName: username, profilePicture: picture)
    }
}

#endif
