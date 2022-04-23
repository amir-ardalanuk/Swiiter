//
//  HomeViewModel.swift
//  Switter
//
//  Created by Amir Ardalan on 4/23/22.
//

import UIKit
import Combine
import Core

class HomeViewModel: HomeViewModelProtocol {
    var tweetStreaming: TweetStreaming
    var state: CurrentValueSubject<HomeState, Never> = .init(.init())


    init(config: HomeModule.Configuration) {
        self.tweetStreaming = config.tweeterStreaming
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Handel Receive Actions
    private func getStream(for keyword: String) {
        updateState(tweets: .isLoading)
        Task {
            do {
                let tweets = try await tweetStreaming.getStream(to: keyword)
                updateState(tweets: .loaded(tweets.map { TweetItem.init(tweet: $0) }), streamKeyword: keyword)
            } catch(let error) {
                updateState(errorMessage: error.localizedDescription)
            }
        }
    }

    func handel(action: HomeAction) {
        switch action {
        case let .search(key):
            getStream(for: key)
        }
    }

    private func updateState(tweets: LoadableDate<[TweetItem]>? = nil,
                             streamKeyword: String? = nil,
                             routing: RouteAction? = nil,
                             errorMessage: String? = nil) {
        let newstate = state.value.update(tweets: tweets, streamKeyword: streamKeyword, routing: routing, errorMessage: errorMessage)
        state.send(newstate)

    }
}

