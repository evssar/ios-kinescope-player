import UIKit
import KinescopeSDK

final class VideoViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var playerView: KinescopePlayerView!

    // MARK: - Private properties

    var videoId = ""
    private var player: KinescopePlayer?

    // MARK: - Lifecycle

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    private let playerConfigProvider = KinescopePlayerConfigProvider()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.delegate = self

        playerView.setLayout(with: .default)

        PipManager.shared.closePipIfNeeded(with: videoId)

        let hlsLink = "https://d3rlna7iyyu8wu.cloudfront.net/skip_armstrong/skip_armstrong_multi_language_subs.m3u8"


//    https://d3rlna7iyyu8wu.cloudfront.net/skip_armstrong/subtitles/ac3_51_eng/subs.m3u8

//        let hlsLink = "https://kinescope.io/202129338/master.m3u8"

        playerConfigProvider.provide(hlsLink: hlsLink) { [weak self] config in
            guard let self = self, let config = config else {
                return
            }

            self.player = KinescopeVideoPlayer(config: config)
            self.player?.attach(view: self.playerView)
            self.player?.play()
            self.playerView.showOverlay(true)
            self.player?.pipDelegate = PipManager.shared
        }
    }
}

extension VideoViewController: UINavigationControllerDelegate {
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return self.supportedInterfaceOrientations
    }
}
