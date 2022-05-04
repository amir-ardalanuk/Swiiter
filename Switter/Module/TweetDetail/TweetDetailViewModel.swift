//
//  TweetDetailViewModel.swift
//  Switter
//
//  Created by Amir Ardalan on 5/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated based on the Clean Swift and MVVM Architecture
//

import Combine
import Foundation

final class TweetDetailViewModel: TweetDetailViewModelProtocol {
    // MARK: - Properties
    var state: CurrentValueSubject<TweetDetailViewModelState, Never>

    // MARK: - Initialize
    init(configuration: TweetDetailModule.Configuration) {
        state = .init(.init(tweet: configuration.tweet))
	}

    // MARK: - Action Handler
    func action(_ handler: TweetDetailViewModelAction) {}
}
