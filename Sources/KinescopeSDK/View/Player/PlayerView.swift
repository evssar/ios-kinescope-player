//
//  PlayerView.swift
//  KinescopeSDK
//
//  Created by Никита Коробейников on 23.03.2021.
//

import UIKit
import AVFoundation

public class PlayerView: UIView {

    // MARK: - Private Properties

    public var player: AVPlayer? {
        get {
            playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }

    var playerLayer: AVPlayerLayer {
        // swiftlint:disable:next force_cast
        return layer as! AVPlayerLayer
    }

    public override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
