import Foundation

struct AccCommentsResp: Codable {
    let data: [AccComment]
}

struct AccComment: Codable {
    let commentId: Int
    let comment: String
    let author: String
    let points: Int
    let children: [AccComment]?

    enum CodingKeys: String, CodingKey {
        case commentId = "id"
        case comment
        case author
        case points
        case children
    }
}
