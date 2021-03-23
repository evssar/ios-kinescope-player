//
//  Manager+KinescopeDownloadable.swift
//  KinescopeSDK
//
//  Created by Никита Коробейников on 23.03.2021.
//

// MARK: - KinescopeDownloadable

class Downoloader: KinescopeDownloadable {

    // MARK: - Properties

    private var delegates: [KinescopeDownloadableDelegate] = []

    private let apiKey: String

    // MARK: - Initialisation

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    // MARK: - Methods

    func isDownloaded(asset_id: String) -> Bool {
        preconditionFailure("Implement")
    }

    func enqeueDownload(asset_id: String) {
        preconditionFailure("Implement")
    }

    func deqeueDownload(asset_id: String) {
        preconditionFailure("Implement")
    }

    func addDelegate(_ delegate: KinescopeDownloadableDelegate) {
        delegates.append(delegate)
    }

    func removeDelegate(_ delegate: KinescopeDownloadableDelegate) {
        if let index = delegates.firstIndex(where: { delegate === $0 }) {
            delegates.remove(at: index)
        }
    }

}
