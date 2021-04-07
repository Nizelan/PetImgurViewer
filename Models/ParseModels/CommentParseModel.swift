import Foundation

struct GalleryCommentResponse: Codable {
    let data: [Comment]
}

struct Comment: Codable {
    let comment: String
    let author: String
    let children: [Comment]?
    let points: Int

    func linkFinder() -> String? {
        var urlString: String?

        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let matches = detector?.matches(in: comment,
                                          options: [],
                                          range: NSRange(location: 0, length: comment.utf16.count)) {
            for mach in matches {
                guard let range = Range(mach.range, in: comment) else { continue }
                let url = comment[range]
                urlString = String(url)
            }
        }

        return urlString
    }
}
