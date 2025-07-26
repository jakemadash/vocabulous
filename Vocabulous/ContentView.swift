import SwiftUI

struct ContentView: View {
    @State private var modelData = ModelData()
    @State private var currentWord: Entry
    @State private var allWords: [Entry]

    init() {
        let model = ModelData()
        let firstWord = model.words.randomElement()!
        
        _modelData = State(initialValue: model)
        _currentWord = State(initialValue: firstWord)
        _allWords = State(initialValue: [firstWord])
    }

    var body: some View {
        HStack {
            if allWords.count > 1 {
                Button {
                if let newWord = modelData.words.randomElement() {
                    currentWord = newWord
                    allWords.append(newWord)
                }
            }
                label: {
                    Label("Go to previous word", systemImage: "chevron.backward")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 30))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            WordDetail(word: currentWord)
            
            Spacer()

            Button {
                if let newWord = modelData.words.randomElement() {
                    currentWord = newWord
                    allWords.append(newWord)
                }
            }
                label: {
                    Label("Go to next word", systemImage: "chevron.forward")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 30))
                        .foregroundColor(.secondary)
                }
            }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
    }
}



#Preview {
    ContentView()
}
