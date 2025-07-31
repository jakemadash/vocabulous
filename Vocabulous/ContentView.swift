import SwiftUI

struct ContentView: View {
    @State private var modelData = ModelData()
    @State private var allWords: [Entry]
    @State private var currentIndex = 0
    
    init() {
        let model = ModelData()
        let firstWord = model.words.randomElement()!
        
        _modelData = State(initialValue: model)
        _allWords = State(initialValue: [firstWord])
    }
    
    private var currentWord: Entry {
        allWords[currentIndex]
    }
    
    private var canGoBack: Bool {
        allWords.count > 1 && currentIndex > 0
    }
    
    private var canGoForward: Bool {
        currentIndex < allWords.count - 1
    }
    
    var body: some View {
        HStack {
            if canGoBack {
                Button(action: goToPreviousWord) {
                    Label("Go to previous word", systemImage: "chevron.backward")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 30))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            WordDetail(word: currentWord)
            
            Spacer()
            
            Button(action: goToNextWord) {
                Label("Go to next word", systemImage: "chevron.forward")
                    .labelStyle(.iconOnly)
                    .font(.system(size: 30))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
    }
    
    // MARK: - Actions
    private func goToPreviousWord() {
        guard canGoBack else { return }
        currentIndex -= 1
    }
    
    private func goToNextWord() {
        if canGoForward {
            currentIndex += 1
        } else {
            addNewRandomWord()
        }
    }
    
    private func addNewRandomWord() {
        guard let newWord = modelData.words.randomElement() else { return }
        allWords.append(newWord)
        currentIndex += 1
    }
}

#Preview {
    ContentView()
}
