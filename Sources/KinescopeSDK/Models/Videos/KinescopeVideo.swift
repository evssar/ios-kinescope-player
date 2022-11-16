//
//  KinescopeVideo.swift
//  KinescopeSDK
//
//  Created by Никита Коробейников on 23.03.2021.
//

public struct KinescopeVideo: Codable {
    public let id: String
    public let projectId: String
    public let version: Int
    public let title: String
    public let description: String
    public let status: String
    public let progress: Int
    public let duration: Double
    public let assets: [KinescopeVideoAsset]
    public let chapters: KinescopeVideoChapter
    public let poster: KinescopeVideoPoster?
    public let additionalMaterials: [KinescopeVideoAdditionalMaterial]
    public let subtitles: [KinescopeVideoSubtitle]
    public let hlsLink: String
}

public extension KinescopeVideo {
    init(hlsLink: String) {
        self.id = ""
        self.projectId = ""
        self.version = 0
        self.title = ""
        self.description = ""
        self.status = ""
        self.progress = 0
        self.duration = 0
        self.assets = []
        self.chapters = KinescopeVideoChapter(items: [])
        self.poster = nil
        self.additionalMaterials = []
        self.subtitles = []
        self.hlsLink = hlsLink
    }
}
