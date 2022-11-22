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
        isMuted: Bool = true,
        looped: Bool = false,
        completion: @escaping (KinescopePlayerConfig?) -> Void
    ) {
        if let videoId = videoId {
            completion(KinescopePlayerConfig(videoId: videoId, video: nil, isMuted: isMuted, looped: looped))
        } else if let hlsLink = hlsLink, let hlsUrl = URL(string: hlsLink) {
            decoder.decode(MasterPlaylist.self, from: hlsUrl) { [weak self] result in
                guard let self = self else {
                    return
                }

                switch result {
                case let .success(playlist):
                    let video = self.makeVideo(from: playlist, hlsLink: hlsLink)
                    let config = KinescopePlayerConfig(videoId: nil, video: video, isMuted: isMuted, looped: looped)

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
        let assets = self.assets(playlist: playlist, hlsLink: hlsLink)

        return KinescopeVideo(
            id: "",
            projectId: "",
            version: 0,
            title: "",
            description: "",
            status: "",
            progress: 0,
            duration: 0,
            assets: assets,
            chapters: .init(items: []),
            poster: nil,
            additionalMaterials: [],
            subtitles: baseSubtitles(subtitles: assets.map { $0.subtitles ?? [] }),
            hlsLink: hlsLink
        )
    }

    private func assets(playlist: MasterPlaylist, hlsLink: String) -> [KinescopeVideoAsset] {
        var videos: [KinescopeVideoAsset] = []

        zip(playlist.ext_x_stream_inf, playlist.uri).forEach { stream, uri in
            let quality = quality(resolution: stream.resolution)

            guard !videos.contains(where: { $0.quality == quality }) else {
                return
            }

            let video = KinescopeVideoAsset(
                id: "",
                videoId: "",
                originalName: "",
                fileSize: 0,
                filetype: fileType(codecs: stream.codecs),
                quality: quality,
                subtitles: makeSubtitles(groupId: stream.subtitles, media: playlist.ext_x_media, hlsLink: hlsLink),
                resolution: resolutinDescription(resolution: stream.resolution),
                createdAt: "",
                updatedAt: nil,
                url: makeUrl(mediaPath: uri, hlsLink: hlsLink) ?? hlsLink
            )

            videos.append(video)
        }

        return videos
    }

    private func baseSubtitles(subtitles: [[KinescopeVideoSubtitle]]) -> [KinescopeVideoSubtitle] {
        guard !subtitles.isEmpty else {
            return []
        }

        var subtitles = subtitles
        var minIndex: Int = 0

        subtitles.enumerated().forEach { offset, _ in
            if subtitles[minIndex].count > subtitles[offset].count {
                minIndex = offset
            }
        }

        let minSubtitles = subtitles[minIndex]
        subtitles.remove(at: minIndex)

        let flatSubtitles = subtitles.flatMap { $0 }

        return minSubtitles.filter { subtitle in
            flatSubtitles.contains(where: { $0.title == subtitle.title })
        }
    }

    private func makeSubtitles(groupId: String?, media: [EXT_X_MEDIA], hlsLink: String) -> [KinescopeVideoSubtitle]? {
        guard let groupId = groupId else {
            return nil
        }

        return media.filter({ $0.group_id == groupId }).compactMap { media in
            guard let language = media.language, let url = makeUrl(mediaPath: media.uri ?? "", hlsLink: hlsLink) else {
                return nil
            }

            return KinescopeVideoSubtitle(description: media.name, language: language, url: url)
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

    private func makeUrl(mediaPath: String, hlsLink: String) -> String? {
        guard var baseUrl = URL(string: hlsLink)?.deletingLastPathComponent(),
                !mediaPath.isEmpty else {
            return nil
        }

        let mediaPath = mediaPath.hasPrefix("/") ? String(mediaPath.dropFirst()) : mediaPath

        if mediaPath.contains("://") {
            return mediaPath
        } else {
            baseUrl.appendPathComponent(mediaPath, isDirectory: false)
            return baseUrl.absoluteString
        }
    }
}
