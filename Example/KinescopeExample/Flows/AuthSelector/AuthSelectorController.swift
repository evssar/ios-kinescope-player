//
//  AuthSelectorController.swift
//  KinescopeExample
//
//  Created by Никита Коробейников on 25.03.2021.
//

import UIKit
import KinescopeSDK

final class AuthSelectorController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyView: UIView!

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Who are you?"
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: nil,
            style: .plain,
            target: nil,
            action: nil
        )

        tableView.register(
            UINib(nibName: cellReuseIdentifire, bundle: nil),
            forCellReuseIdentifier: cellReuseIdentifire
        )

        loadUsers()
    }

    private let cellReuseIdentifire = "UserCell"

    private var users: [User] = []
}

// MARK: - Private Methods

private extension AuthSelectorController {

    func loadUsers() {
        users = ConfigStorage.read()

        tableView.reloadData()

        emptyView.isHidden = !users.isEmpty

    }

    func onSelect(user: User) {

        /// Set apiKey
        Kinescope.shared.setConfig(.init(apiKey: user.apiKey))

        /// Set logger
        Kinescope.shared.set(
            logger: KinescopeDefaultLogger(),
            levels: KinescopeLoggerLevel.allCases
        )

        /// Push to next
        performSegue(withIdentifier: "toVideos", sender: nil)

    }

}

extension AuthSelectorController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        min(1, users.count)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellReuseIdentifire,
            for: indexPath
        )

        (cell as? UserCell)?.configure(with: users[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect(user: users[indexPath.row])
    }
}
