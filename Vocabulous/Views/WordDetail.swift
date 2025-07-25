import SwiftUI

struct WordDetail: View {
    var word: Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(word.lemma.capitalized)
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(Color(red: 0.784, green: 0.063, blue: 0.180))

            if let pos = word.pos {
                Text(pos)
                    .font(.system(size: 20, weight: .regular))
                    .italic()
            }

            Text(word.enlemma.capitalized)
                .font(.system(size: 24, weight: .regular))
                .foregroundStyle(Color(red: 0.0, green: 0.694, blue: 0.251))

            if let clar = word.clar {
                Text("Clarification: \(clar)")
                    .font(.body)
            }

            if let gender = word.gender {
                Text("Gender: \(gender)")
                    .font(.body)
            }

            if let tense = word.tense {
                Text("Tense: \(tense)")
                    .font(.body)
            }

            if let notes = word.notes {
                Text("Notes: \(notes)")
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}


#Preview {
    let modelData = ModelData()
    WordDetail(word: modelData.words[0])
}
