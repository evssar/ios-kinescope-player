protocol KinescopePlayerViewDelegate: AnyObject {
    func didPlay()
    func didPause()
    func didSeek(to position: Double)
    func didMute()
    func didClose()
    func didConfirmSeek()
    func didFastForward()
    func didFastBackward()
    func didPresentFullscreen(from view: KinescopePlayerView)
    func didShowQuality() -> [String]
    func didShowPlaybackSpeed() -> [String]
    func didShowAttachments() -> [KinescopeVideoAdditionalMaterial]?
    func didShowAssets() -> [KinescopeVideoAsset]?
    func didSelect(quality: String)
    func didSelect(playbackSpeed: String)
    func didSelectAttachment(with index: Int)
    func didSelectAsset(with index: Int)
    func didSelectDownloadAll(for title: String)
    func didShowSubtitles() -> [String]
    func didSelect(subtitles: String)
}
