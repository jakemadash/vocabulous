import SwiftUI

struct WordDetail: View {
    @Environment(ModelData.self) var modelData
    var word: Entry
    var body: some View {
        Text("\(word.lemma)")
    }
}

#Preview {
    let modelData = ModelData()
    return WordDetail(word: modelData.words[0])
        .environment(modelData)
}
