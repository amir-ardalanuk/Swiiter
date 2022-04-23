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

protocol HomeRouting: Router {}

final class HomeRouter: HomeRouting {
    weak var viewController: UIViewController?

    private var homeViewController: HomeViewController {
        return viewController as! HomeViewController
    }

    init() {}
}
