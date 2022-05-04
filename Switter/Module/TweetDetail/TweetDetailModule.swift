//
//  TweetDetailModule.swift
//  Switter
//
//  Created by Amir Ardalan on 5/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated based on the Clean Swift and MVVM Architecture
//

import UIKit
import Core

enum TweetDetailModule {

    struct Configuration {
        let tweet: Tweet
    }

    // MARK: - Alias
    typealias Config = Configuration
	typealias SceneView = TweetDetailViewController
	
	static func build(with configuration: Config) -> SceneView {
		let viewModel = TweetDetailViewModel(configuration: configuration)
		let router = TweetDetailRouter()
		let viewController = SceneView(viewModel: viewModel, router: router)
		
		router.viewController = viewController
		return viewController
	}
}
