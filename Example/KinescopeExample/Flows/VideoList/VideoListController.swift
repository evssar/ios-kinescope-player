//
//  VideoListController.swift
//  KinescopeExample
//
//  Created by Никита Коробейников on 23.03.2021.
//

import AVKit
import UIKit
import KinescopeSDK

/// Example of video gallery
final class VideoListController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(
                UINib(nibName: cellReuseIdentifire, bundle: nil),
                forCellReuseIdentifier: cellReuseIdentifire
            )

            tableView.contentInset.bottom = 200
            tableView.estimatedRowHeight = 200
        }
    }

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private let inspector: KinescopeInspectable = Kinescope.shared.inspector
    private let cellReuseIdentifire = "VideoListCell"
    private let playerConfigProvider = KinescopePlayerConfigProvider()

    let avPlayerViewController = AVPlayerViewController()
    var avPlayer: AVPlayer?
    let movieURL = "https://kinescope.io/202129338/master.m3u8"

    private var videos: [KinescopeVideo] = []

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Your videos"
        loadVideos()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard
            let destination = segue.destination as? VideoViewController,
            let id = sender as? String
        else {
            return
        }

        destination.videoId = id
    }
}

// MARK: - Private Methods

private extension VideoListController {
    func loadVideos() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true

        inspector.list(
            request: KinescopeVideosRequest(page: 1),
            onSuccess: { [weak self] response in
                guard let self = self else {
                    return
                }

                self.videos = response.0
                self.tableView.reloadData()
                self.activityIndicator?.stopAnimating()
            },
            onError: { _ in
                print("Error loading videos")
            })
    }
}

extension VideoListController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        min(1, videos.count)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        videos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellReuseIdentifire,
            for: indexPath
        )

        (cell as? VideoListCell)?.configure(with: videos[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* performSegue(withIdentifier: "toVideo", sender: videos[indexPath.row].id) */

        let hlsLink = "https://d3rlna7iyyu8wu.cloudfront.net/skip_armstrong/skip_armstrong_multi_language_subs.m3u8"

        /* let hlsLink = "https://kinescope.io/202129338/master.m3u8" */

        playerConfigProvider.provide(hlsLink: hlsLink) { [weak self] config in
            guard let self = self, let config = config else {
                return
            }

            let player = KinescopeFullScreenVideoPlayer(config: config)
            player.pipDelegate = PipManager.shared
            player.delegate = self

            let playerVC = KinescopeVideoPlayerViewController(
                player: player,
                config: .init(
                    orientation: .landscapeRight,
                    orientationMask: .all,
                    backgroundColor: .black
                ))

            self.present(playerVC, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? VideoListCell)?.start()
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? VideoListCell)?.stop()
    }
}

extension VideoListController: KinescopeVideoPlayerDelegate {
    func playerDidClose() {
        dismiss(animated: true)
    }
}
