//
//  KinescopePlayerConfig.swift
//  KinescopeSDK
//
//  Created by Никита Коробейников on 29.03.2021.
//

/// Configuration entity required to connect resource with player
public struct KinescopePlayerConfig {

    /// Id of concrete video. For example from [GET Videos list](https://documenter.getpostman.com/view/10589901/TVCcXpNM)
    public let videoId: String?

    public let video: KinescopeVideo?

    /// If value is `true` show video in infinite loop.
    public let looped: Bool

    /// - parameter videoId: Id of concrete video. For example from [GET Videos list](https://documenter.getpostman.com/view/10589901/TVCcXpNM)
    /// - parameter looped: If value is `true` show video in infinite loop. By default is `false`
    public init(videoId: String?, video: KinescopeVideo?, looped: Bool = false) {
        self.videoId = videoId
        self.video = video
        self.looped = looped
    }

}
