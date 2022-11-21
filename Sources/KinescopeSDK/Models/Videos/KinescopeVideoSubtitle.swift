import Foundation

public struct KinescopeVideoSubtitle: Codable {
    public let description: String
    public let language: String
    public let url: String
}

extension KinescopeVideoSubtitle {
    var title: String {
        let str = Locale(identifier: language).localizedString(forIdentifier: language) ?? language
        return str.capitalized
    }
}
