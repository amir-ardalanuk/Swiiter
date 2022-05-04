//
//  TweetDetailViewController.swift
//  Switter
//
//  Created by Amir Ardalan on 5/3/22.
//  Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated based on the Clean Swift and MVVM Architecture
//

import Combine
import Foundation
import UIKit

class TweetDetailViewController: UIViewController {
    // MARK: - UI Components
    lazy private var tweetView: TweetView = {
        let view = TweetView(configuration: TweetConfiguration.init(item: nil))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.preservesSuperviewLayoutMargins = true
        return view
    }()

    // MARK: - Properties
    private var router: TweetDetailRouting?
    private var viewModel: TweetDetailViewModelProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialize

    init(viewModel: TweetDetailViewModelProtocol, router: TweetDetailRouting?) {
        self.viewModel =  viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail"
        prepareUI()
        bind()
    }

    // MARK: - Bind ViewModel

    func bind() {
        viewModel.state
            .map(\.tweet)
            .sink { [weak self] tweet in
                self?.tweetView.configuration = TweetConfiguration(item: tweet)
            }.store(in: &cancellables)
    }

    // MARK: - Prepare UI

    func prepareUI() {
        view.backgroundColor = .white
        view.addSubview(tweetView)
        view.directionalLayoutMargins = .init(top: 16, leading: 8, bottom: 16, trailing: 8)
        NSLayoutConstraint.activate([
            tweetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tweetView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tweetView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }

    // MARK: - Actions
}
