//
//  File.swift
//  
//
//  Created by Amir Ardalan on 5/4/22.
//

import Foundation 
// MARK: - RuleRequest
struct RuleRequest: Encodable {
    let add: [Rule]
}

// MARK: - Add
struct Rule: Encodable {
    let value, tag: String
}
