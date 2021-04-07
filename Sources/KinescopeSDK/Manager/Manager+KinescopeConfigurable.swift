//
//  Manager+KinescopeConfigurable.swift
//  KinescopeSDK
//
//  Created by Никита Коробейников on 23.03.2021.
//

// MARK: - KinescopeConfigurable

extension Manager: KinescopeConfigurable {

    func setConfig(_ config: KinescopeConfig) {
        self.config = config
        self.downloader = AssetDownloader(assetPathsStorage: AssetPathsUDStorage(),
                                          assetService: AssetNetworkService(assetsService: AssetLinksNetworkService(transport: Transport(), config: config)))
        self.inspector = Inspector(videosService: VideosNetworkService(transport: Transport(),
                                                                       config: config))
    }

    func set(logger: KinescopeLogging, levels: [KinescopeLoggingLevel]) {
        self.logger = KinescopeLogger(logger: logger, levels: levels)
    }
}
