//
//  KinescopePlayerViewConfiguration.swift
//  KinescopeSDK
//
//  Created by Никита Коробейников on 30.03.2021.
//

import AVFoundation
import UIKit

/// Appearance preferences of player view
public struct KinescopePlayerViewConfiguration {

    let gravity: AVLayerVideoGravity
    let activityIndicator: KinescopeActivityIndicator
    let overlay: KinescopePlayerOverlayConfiguration?
    let controlPanel: KinescopeControlPanelConfiguration?
    let sideMenu: KinescopeSideMenuConfiguration
    let shadowOverlay: KinescopePlayerShadowOverlayConfiguration?
    let errorState: KinescopeErrorViewConfiguration
    let nameDisplayingType: KinescopeVideoNameDisplayingType
    let nameConfiguration: KinescopeVideoNameConfiguration

    /// - parameter gravity: `AVLayerVideoGravity` value defines how the video is displayed within a layer’s bounds rectangle
    /// - parameter activityIndicator: Custom indicator view used to indicate process of video downloading
    /// - parameter overlay: Configuration of overlay with tapGesture to play/pause video
    ///  Set `nil` to hide overlay (usefull for videos collection with autoplaying)
    /// - parameter controlPanel: Configuration of control panel with play/pause buttons and other controls
    /// Set `nil` to hide control panel
    /// - parameter sideMenu: Configuration of side menu with setings
    /// - parameter shadowOverlay: Configuration of shadow overlay beneath side menu
    /// - parameter errorState: Configuration of error state view
    /// - parameter nameDisplayingType: Type of displaying view with title and description of video
    /// - parameter nameConfiguration: Configuration of video title and description lables
    public init(gravity: AVLayerVideoGravity,
                activityIndicator: KinescopeActivityIndicator = KinescopeSpinner(frame: CGRect(x: 0, y: 0, width: 32, height: 32)),
                overlay: KinescopePlayerOverlayConfiguration? = .default,
                controlPanel: KinescopeControlPanelConfiguration? = .default,
                sideMenu: KinescopeSideMenuConfiguration = .default,
                shadowOverlay: KinescopePlayerShadowOverlayConfiguration? = .default,
                errorState: KinescopeErrorViewConfiguration = .default,
                nameDisplayingType: KinescopeVideoNameDisplayingType = .hidesWithOverlay,
                nameConfiguration: KinescopeVideoNameConfiguration = .default) {
        self.gravity = gravity
        self.activityIndicator = activityIndicator
        self.overlay = overlay
        self.controlPanel = controlPanel
        self.sideMenu = sideMenu
        self.shadowOverlay = shadowOverlay
        self.errorState = errorState
        self.nameDisplayingType = nameDisplayingType
        self.nameConfiguration = nameConfiguration
    }

}

// MARK: - Defaults

public extension KinescopePlayerViewConfiguration {

    static let `default`: KinescopePlayerViewConfiguration = .init(gravity: .resizeAspect,
                                                                   activityIndicator: KinescopeSpinner(frame: CGRect(x: 0, y: 0, width: 32, height: 32)),
                                                                   overlay: .default,
                                                                   controlPanel: .default,
                                                                   sideMenu: .default,
                                                                   shadowOverlay: .default,
                                                                   errorState: .default,
                                                                   nameDisplayingType: .hidesWithOverlay,
                                                                   nameConfiguration: .default)

}
