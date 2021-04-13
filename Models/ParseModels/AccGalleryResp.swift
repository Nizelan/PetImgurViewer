import Foundation
import CoreGraphics

struct AccGalleryResp: Codable {
    let data: [AccPost]
}

struct AccPost: Codable {
    let postId: String
    let title: String?
    let link: String
    let width: Int
    let height: Int

    enum CodingKeys: String, CodingKey {
        case postId = "id"
        case title
        case link
        case width
        case height
    }
}

extension AccPost {
    var coverSize: CGSize {
        return CGSize(width: width, height: height)
    }

    var aspectRatio: CGFloat {
        return CGFloat(width) / CGFloat(height)
    }
}
