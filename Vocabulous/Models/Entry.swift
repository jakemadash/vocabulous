import Foundation

struct Entry: Hashable, Codable, Identifiable {
    let id: Int
    let lemma: String
    let enlemma: String
    let clar: String?
    let pos: String?
    let gender: String?
    let tense: String?
    let notes: String?
}
