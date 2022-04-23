//
//  HomeViewModelProtocol.swift
//  Switter
//
//  Created by Amir Ardalan on 4/23/22.
//

import Foundation
import Core
import Combine

//MARK: - Base Protocol
protocol HomeViewModelProtocol {
    func handel(action: HomeAction)
    var state: CurrentValueSubject<HomeState, Never> { get }
}

//MARK: - Action
enum HomeAction: Hashable {
    case search(String)
}

enum LoadableDate<T: Hashable> {
    case notRequested
    case loaded(T)
    case error(String?)
    case isLoading

    public var value: T? {
        switch self {
        case let .loaded(value): return value
        default: return nil
        }
    }

    public var error: String? {
        switch self {
        case let .error(message): return message
        default: return nil
        }
    }

    public  var isLoading: Bool {
        switch self {
        case  .isLoading: return true
        default: return false
        }
    }
}

struct TweetItem: Hashable, Identifiable {
    var id: TweetId { tweet.id }

    let tweet: Tweet
}

enum RouteAction {
    case openTweetDetail
}

//MARK: - State
struct HomeState {
    var tweets: LoadableDate<[TweetItem]>?
    var streamKeyword: String?
    var routing: RouteAction?
    var errorMessage: String?

    func update(
        tweets: LoadableDate<[TweetItem]>? = nil,
        streamKeyword: String? = nil,
        routing: RouteAction? = nil,
        errorMessage: String? = nil
    ) -> HomeState {
        .init(
            tweets: tweets ?? self.tweets,
            streamKeyword: streamKeyword ?? self.streamKeyword,
            routing: routing ?? self.routing,
            errorMessage: errorMessage
        )
    }
}

