//
//  PlaybackManager.swift
//  KinescopeSDK
//
//  Created by Artemii Shabanov on 20.05.2021.
//

import Foundation

protocol PlaybackManagerDelegate: AnyObject {
    /// Unique video seconds watched
    func uniqueSecondsUpdated(seconds: Int)
    /// For "view" analytics events. Called once
    func viewSecondsReached()
    /// Every 2% of video. At least once at 60 seconds
    func playbackActionTriggered(second: Int)
    /// time: buffering duration
    func bufferingActionTriggered(time: TimeInterval)
}

// Handles player playback actions for analytics
final class PlaybackManager {

    // MARK: - Properties

    weak var delegate: PlaybackManagerDelegate?
    private let playbackStep: Int
    private let viewSeconds: Int
    private var uniqueSeconds: Set<Int> = .init()
    private var viewSecondsReachedWasSend = false
    private var lastRegisteredPlaybackStep: Int?
    private var bufferingStart: Date?

    // MARK: - Init

    init(duration: Int, viewSeconds: Int) {
        self.playbackStep = min(max(duration / 50, 5), 60)
        self.viewSeconds = viewSeconds
    }

    // MARK: - Internal Methods

    func register(second: Int) {
        if !uniqueSeconds.contains(second) {
            uniqueSeconds.insert(second)
            delegate?.uniqueSecondsUpdated(seconds: uniqueSeconds.count)
            handleViewSecondsReached()
        }
        handlePlayback(second: second)
    }

    func startBuffering() {
        bufferingStart = Date()
    }

    func stopBuffering() {
        guard let bufferingStart = bufferingStart else {
            return
        }
        delegate?.bufferingActionTriggered(time: Date().timeIntervalSince(bufferingStart))
    }

    // MARK: - Private Methods

    private func handleViewSecondsReached() {
        guard !viewSecondsReachedWasSend else {
            return
        }
        if uniqueSeconds.count >= viewSeconds {
            delegate?.viewSecondsReached()
            viewSecondsReachedWasSend = true
        }
    }

    private func handlePlayback(second: Int) {
        if let lastRegisteredPlaybackStep = lastRegisteredPlaybackStep {
            let prevStep = lastRegisteredPlaybackStep - playbackStep
            let nextStep = lastRegisteredPlaybackStep + playbackStep
            if second >= nextStep || second <= prevStep {
                delegate?.playbackActionTriggered(second: second)
            }
        } else {
            delegate?.playbackActionTriggered(second: second)
        }
        lastRegisteredPlaybackStep = second
    }

}
