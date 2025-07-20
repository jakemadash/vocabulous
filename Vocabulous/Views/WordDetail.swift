import SwiftUI

struct WordDetail: View {
    @Environment(ModelData.self) var modelData
    var word: Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text(word.lemma.capitalized)
                .font(.system(size: 34, weight: .bold))
            Text(word.enlemma.capitalized)
                .font(.system(size: 24, weight: .regular))
            Text(word.pos ?? "")
                .font(.system(size: 20, weight: .regular))
                .italic()
        }
        .padding()
    }
}

#Preview {
    let modelData = ModelData()
    return WordDetail(word: modelData.words[0])
        .environment(modelData)
}
