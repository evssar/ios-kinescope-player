//
//  File.swift
//  
//
//  Created by Eugene Sorokin on 16.11.2022.
//

import Foundation
import M3U8Decoder

public class KinescopePlayerConfigProvider {
    private let decoder = M3U8Decoder()

    public init() {}

    public func provide(
        videoId: String? = nil,
        hlsLink: String? = nil,
        looped: Bool = false,
        completion: @escaping (KinescopePlayerConfig?) -> Void
    ) {
        if let videoId = videoId {
            completion(KinescopePlayerConfig(videoId: videoId, video: nil, looped: looped))
        } else if let hlsLink = hlsLink, let hlsUrl = URL(string: hlsLink) {
            decoder.decode(MasterPlaylist.self, from: hlsUrl) { [weak self] result in
                guard let self = self else {
                    return
                }

                switch result {
                case let .success(playlist):
                    let video = self.makeVideo(from: playlist, hlsLink: hlsLink)
                    let config = KinescopePlayerConfig(videoId: nil, video: video, looped: looped)

                    DispatchQueue.main.async {
                        completion(config)
                    }
                case .failure:
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }

            }
        } else {
            completion(nil)
        }
    }

    private func makeVideo(from playlist: MasterPlaylist, hlsLink: String) -> KinescopeVideo {
        KinescopeVideo(
            id: "",
            projectId: "",
            version: 0,
            title: "",
            description: "",
            status: "",
            progress: 0,
            duration: 0,
            assets: assets(streams: playlist.ext_x_stream_inf, uris: playlist.uri),
            chapters: .init(items: []),
            poster: nil,
            additionalMaterials: [],
            subtitles: [],
            hlsLink: hlsLink
        )
    }

    private func assets(streams: [EXT_X_STREAM_INF], uris: [String]) -> [KinescopeVideoAsset] {
        zip(streams, uris).map { stream, uri in
            KinescopeVideoAsset(
                id: "",
                videoId: "",
                originalName: "",
                fileSize: 0,
                filetype: fileType(codecs: stream.codecs),
                quality: quality(resolution: stream.resolution),
                resolution: resolutinDescription(resolution: stream.resolution),
                createdAt: "",
                updatedAt: nil,
                url: uri
            )
        }
    }

    private func resolutinDescription(resolution: RESOLUTION?) -> String {
        guard let resolution = resolution else {
            return ""
        }

        return "\(resolution.width)x\(resolution.height)"
    }

    private func quality(resolution: RESOLUTION?) -> String {
        guard let resolution = resolution else {
            return ""
        }

        return "\(resolution.height)p"
    }

    private func fileType(codecs: [String]) -> String {
        if codecs.contains(where: {
            $0.hasPrefix("mp4")
        }) {
            return "mp4"
        } else {
            return ""
        }
    }
}
