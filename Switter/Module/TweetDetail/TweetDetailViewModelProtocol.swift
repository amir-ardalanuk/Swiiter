//
//  TweetDetailViewModelProtocol.swift
//  Switter
//
//  Created by Amir Ardalan on 5/3/22.
//

import Foundation
import Combine
import Core

protocol TweetDetailViewModelProtocol {
    var state: CurrentValueSubject<TweetDetailViewModelState, Never> { get }
    func action(_ handler: TweetDetailViewModelAction)
}

struct TweetDetailViewModelState {
    let tweet: Tweet?
}
enum TweetDetailViewModelAction { }

