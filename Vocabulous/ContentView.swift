import SwiftUI

struct ContentView: View {
    @State private var modelData = ModelData()
    @State private var currentWord: Entry

    init() {
        let model = ModelData()
        _modelData = State(initialValue: model)
        _currentWord = State(initialValue: model.words.randomElement()!)
    }

    var body: some View {
        VStack(spacing: 40) {
            WordDetail(word: currentWord)

            Button("Show Another Word") {
                if let newWord = modelData.words.randomElement() {
                    currentWord = newWord
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environment(modelData)
    }
}



#Preview {
    ContentView()
}
