//
//  HomeViewController.swift
//  Switter
//
//  Created by Amir Ardalan on 4/23/22.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    // MARK: - Properties
    private var cancellabels = Set<AnyCancellable>()
    let viewModel: HomeViewModelProtocol
    let router: HomeRouting
    private let searchTextPublisher = PassthroughSubject<String, Never>()

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = Constant.placeholder
        return searchBar
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = refreshController
        tableView.estimatedRowHeight = Constant.estimateHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInset = Constant.listContentInset
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        return tableView
    }()

    lazy var refreshController: UIRefreshControl = { UIRefreshControl() }()
    lazy var datasource: UITableViewDiffableDataSource = makeDatasource()

    // MARK: - Init
    init(viewModel: HomeViewModelProtocol, router: HomeRouting) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Has not implemented")
    }

    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }

    // MARK: - Setup and Constraint Views
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.titleView = searchBar
        view.addSubview(tableView)
        makeTableViewConstraint()
        tableView.reloadData()
    }

    private func makeTableViewConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

    private func bind() {
        searchTextPublisher
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] data in
                self?.viewModel.handel(action: .search(data))
        }.store(in: &cancellabels)

        viewModel.state
            .receive(on: RunLoop.main)
            .compactMap(\.tweets?.isLoading)
            .sink { [weak self] isLoading in
                isLoading ? self?.refreshController.beginRefreshing() : self?.refreshController.endRefreshing()
        }.store(in: &cancellabels)

        viewModel.state
            .receive(on: RunLoop.main)
            .compactMap(\.tweets?.error)
            .sink { error in
                // FIXME: Show dialog to the user to try again
                print(error)
        }.store(in: &cancellabels)

        viewModel.state
            .receive(on: RunLoop.main)
            .compactMap(\.tweets?.value)
            .sink { [weak self] tweets in
                self?.makeSnopshot(tweets)
        }.store(in: &cancellabels)

        viewModel.state
            .compactMap(\.routing)
            .receive(on: RunLoop.main)
            .sink { [weak self] route in
                switch route {
                case let .tweetDetail(tweet):
                    self?.router.showDetail(of: tweet)
                }
        }.store(in: &cancellabels)
    }

    func makeSnopshot(_ tweets: [TweetItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, TweetItem.ID>()
        snapshot.appendSections([0])
        snapshot.appendItems(tweets.map(\.id), toSection: 0)
        datasource.apply(snapshot, animatingDifferences: false)
    }
    private func makeDatasource() -> UITableViewDiffableDataSource<Int, TweetItem.ID> {
        UITableViewDiffableDataSource<Int, TweetItem.ID>(tableView: tableView) { [weak self]
           (tableView: UITableView, indexPath: IndexPath, itemIdentifier: TweetItem.ID) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
            if let item = self?.viewModel.state.value.tweets?.value?[indexPath.row] {
                cell.contentConfiguration = TweetConfiguration(item: item.tweet)
            }
            return cell
       }
    }
}

// MARK: - TableViewDelegate

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.selectionStyle = .none
        viewModel.handel(action: .selectTweet(indexPath))
    }
}

// MARK: - Constant
extension HomeViewController {
    enum Constant {
        static let placeholder = "Search keyword ... "
        static let estimateHeight = 50.0
        static let listContentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextPublisher.send(searchText)
    }
}
