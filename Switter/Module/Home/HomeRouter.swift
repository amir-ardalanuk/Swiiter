//
//  HomeRouter.swift
//  Switter
//
//  Created by Amir Ardalan on 4/23/22.
//

import Foundation
import UIKit
import Core
import Combine

protocol HomeRouting: Router {
    func showDetail(of tweet: Tweet)
}

final class HomeRouter: HomeRouting {
    weak var viewController: UIViewController?

    private var homeViewController: HomeViewController {
        return viewController as! HomeViewController
    }

    init() {}

    func showDetail(of tweet: Tweet) {
        let destination = TweetDetailModule.build(with: .init(tweet: tweet))
        viewController?.navigationController?.pushViewController(destination, animated: true)
    }
}
