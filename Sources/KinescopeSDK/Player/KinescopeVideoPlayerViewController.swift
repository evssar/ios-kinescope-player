//
//  File.swift
//  
//
//  Created by Eugene Sorokin on 21.11.2022.
//


import UIKit

final public class KinescopeVideoPlayerViewController: UIViewController {

    // MARK: - Private properties

    private weak var playerView: KinescopePlayerView!

    private var player: KinescopePlayer!

    private let config: KinescopeFullscreenConfiguration

    // MARK: - Init

    public init(player: KinescopePlayer, config: KinescopeFullscreenConfiguration) {
        self.player = player
        self.config = config

        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        modalPresentationCapturesStatusBarAppearance = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Orientation style

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        config.orientationMask
    }

    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        config.orientation
    }

    public override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }

    public override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialState()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.attach(view: playerView)
        player.play()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.stop()
        player.detach(view: playerView)
    }

    public override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            player.detach(view: playerView)
        }
    }
}

// MARK: - Private

private extension KinescopeVideoPlayerViewController {
    func setupInitialState() {
        view.backgroundColor = config.backgroundColor

        let playerView = KinescopePlayerView()
        playerView.setLayout(with: .default)
        view.addSubview(playerView)
        view.stretch(view: playerView)

        self.playerView = playerView
    }
}
