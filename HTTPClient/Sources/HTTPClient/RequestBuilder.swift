//
//  File.swift
//  
//
//  Created by Amir Ardalan on 5/4/22.
//

import Foundation

public enum RequestableError: Error {
    case invalidRequest
}

public enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case delete = "DELETE"
    case patch = "PATCH"
}

open class RequestBuilder {
    var baseURL: URL
    var path: String
    var method: HTTPMethod = .get
    var headers: [String: String]?
    var urlParameters: [String: Any]?
    var body: Data?

    init(with baseURL: URL, path: String) {
        self.baseURL = baseURL
        self.path = path
    }

    func set(method: HTTPMethod) -> Self {
        self.method = method
        return self
    }

    func set(path: String) -> Self {
        self.path = path
        return self
    }

    func set(headers: [String: String]?) -> Self {
        self.headers = headers
        return self
    }

    func set(urlParameters: [String: LosslessStringConvertible]?) -> Self {
        self.urlParameters = urlParameters
        return self
    }

    func set(body: Data?) -> Self {
        self.body = body
        return self
    }

    func set<T: Encodable>(body: T?) throws -> Self {
        self.body = try JSONEncoder().encode(body)
        return self
    }

    func build() throws -> URLRequest {
        guard var urlComponent = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: true) else {
            throw RequestableError.invalidRequest
        }
        urlComponent.queryItems = .init(dictionary: self.urlParameters!)
        urlParameters.flatMap { params in
            urlComponent.queryItems = .init(dictionary: params)
        }
        guard let url = urlComponent.url else {
            throw RequestableError.invalidRequest
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue

        headers?.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }

        if let params = body {
            urlRequest.httpBody = params
        }
        return urlRequest
    }

}

extension Collection where Element == URLQueryItem {
    subscript(_ name: String) -> String? {
        first(where: { $0.name == name })?.value
    }
}

extension Array where Element == URLQueryItem {
    init<T: LosslessStringConvertible>(dictionary: [String: T]) {
        self = dictionary.map({ (key, value) -> Element in
            URLQueryItem(name: key, value: String(value))
        })
    }

    init(dictionary: [String: Any]) {
        self = dictionary.compactMap { (key: String, value: Any) in
            if let value = value as? LosslessStringConvertible {
                return (key, value.description)
            } else {
                return nil
            }
        }.map { (key, value) -> URLQueryItem in
            URLQueryItem(name: key, value: value)
        }
    }
}
