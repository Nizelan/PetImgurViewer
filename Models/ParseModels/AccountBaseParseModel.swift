import Foundation

struct AccountBaseResponse: Codable {
    let data: AccountBase
}

struct AccountBase: Codable {
    let id: Int
    let url: String
    let avatar: String
    let reputation: Int
}
