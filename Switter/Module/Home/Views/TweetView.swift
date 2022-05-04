//
//  TweetView.swift
//  Switter
//
//  Created by Amir Ardalan on 4/23/22.
//

import UIKit
import Core
import SDWebImage

class TweetView: UIView, UIContentView {

    // MARK: - Views
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Constant.mainStackSpacing
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var profileTextStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Constant.textStackSpacing
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var profileInfoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Constant.textStackSpacing
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.axis = .horizontal
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()

    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Constant.profileImageSize.width / 2
        imageView.clipsToBounds = true
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        return imageView
    }()

    // MARK: - Properties
    private var tweetConfiguration: TweetConfiguration? {
        configuration as? TweetConfiguration
    }

    var configuration: UIContentConfiguration {
        didSet {
            configView()
        }
    }

    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupView()
        configView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SetupView
    private func setupView() {
        addSubview(mainStackView)
        [titleLabel, descriptionLabel].forEach(profileTextStack.addArrangedSubview(_:))
        [profileImageView, profileTextStack].forEach(profileInfoStack.addArrangedSubview(_:))
        [profileInfoStack, textLabel].forEach(mainStackView.addArrangedSubview(_:))

        setupConstraint()
    }

    private func setupConstraint() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: Constant.verticalPadding),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.verticalPadding),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.horizontalPadding),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.horizontalPadding),
        ])

        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: Constant.profileImageSize.width),
            profileImageView.heightAnchor.constraint(equalToConstant: Constant.profileImageSize.height),
        ])
    }
    // MARK: - fetch Config on View

    private func configView() {
        guard let configuration = tweetConfiguration, let tweet = configuration.item else { return }
        titleLabel.text = tweet.author.userName
        descriptionLabel.text = tweet.id.id
        profileImageView.sd_setImage(with: tweet.author.profilePicture)
        textLabel.text = tweet.text
    }

}

extension TweetView {
    enum Constant {
        static let horizontalPadding = 16.0
        static let verticalPadding = 8.0
        static let textStackSpacing = 8.0
        static let mainStackSpacing = 16.0
        static let profileImageSize = CGSize(width: 50, height: 50)
    }
}

struct TweetConfiguration: UIContentConfiguration {
    let item: Tweet?

    func makeContentView() -> UIView & UIContentView {
        TweetView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> TweetConfiguration {
        self
    }
}
