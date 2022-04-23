//
//  FeatureModule.swift
//  Switter
//
//  Created by Amir Ardalan on 4/23/22.
//

import Foundation

protocol FeatureModule {
    associatedtype Controller
    associatedtype Configuration

    static func makeScene(configuration: Configuration) -> Controller
}
