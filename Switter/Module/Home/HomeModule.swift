//
//  HomeModule.swift
//  Switter
//
//  Created by Amir Ardalan on 4/23/22.
//

import Foundation
import Core

enum HomeModule: FeatureModule {

    struct Configuration {
        let tweeterStreaming: TweetStreaming
    }

    typealias Controller = HomeViewController

    static func makeScene(configuration: Configuration) -> Controller {
        let viewModel = HomeViewModel(config: configuration)
        let router = HomeRouter()
        let viewController = HomeViewController(viewModel: viewModel, router: router)

        router.viewController = viewController

        return viewController
    }
}
