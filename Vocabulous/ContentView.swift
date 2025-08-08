import SwiftUI
import UIKit

// MARK: - UIPageViewController Wrapper
struct PageCurlView: UIViewControllerRepresentable {
    @Binding var allWords: [Entry]
    @Binding var currentIndex: Int
    let onAddNewWord: () -> Void
    
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .pageCurl,
            navigationOrientation: .horizontal
        )
        
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        
        if !allWords.isEmpty {
            let initialVC = WordDetailViewController(word: allWords[currentIndex])
            pageViewController.setViewControllers([initialVC], direction: .forward, animated: false)
        }
        
        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        guard !allWords.isEmpty,
              let currentVC = pageViewController.viewControllers?.first as? WordDetailViewController,
              currentVC.word.lemma != allWords[currentIndex].lemma else { return }
        
        let newVC = WordDetailViewController(word: allWords[currentIndex])
        let direction: UIPageViewController.NavigationDirection =
            context.coordinator.lastIndex < currentIndex ? .forward : .reverse
        
        pageViewController.setViewControllers([newVC], direction: direction, animated: true)
        context.coordinator.lastIndex = currentIndex
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        let parent: PageCurlView
        var lastIndex: Int
        
        init(_ parent: PageCurlView) {
            self.parent = parent
            self.lastIndex = parent.currentIndex
        }
        
        // MARK: - UIPageViewControllerDataSource
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let wordVC = viewController as? WordDetailViewController,
                  let currentWordIndex = parent.allWords.firstIndex(where: { $0.lemma == wordVC.word.lemma }),
                  currentWordIndex > 0 else { return nil }
            
            return WordDetailViewController(word: parent.allWords[currentWordIndex - 1])
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let wordVC = viewController as? WordDetailViewController,
                  let currentWordIndex = parent.allWords.firstIndex(where: { $0.lemma == wordVC.word.lemma }) else { return nil }
            
            if currentWordIndex < parent.allWords.count - 1 {
                return WordDetailViewController(word: parent.allWords[currentWordIndex + 1])
            } else {
                parent.onAddNewWord()
                if currentWordIndex < parent.allWords.count - 1 {
                    return WordDetailViewController(word: parent.allWords[currentWordIndex + 1])
                }
            }
            
            return nil
        }
        
        // MARK: - UIPageViewControllerDelegate
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            guard completed,
                  let currentVC = pageViewController.viewControllers?.first as? WordDetailViewController,
                  let newIndex = parent.allWords.firstIndex(where: { $0.lemma == currentVC.word.lemma }) else { return }
            
            parent.currentIndex = newIndex
            lastIndex = newIndex
        }
    }
}

// MARK: - Individual Word View Controller
class WordDetailViewController: UIViewController {
    let word: Entry
    
    init(word: Entry) {
        self.word = word
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwiftUIView()
    }
    
    private func setupSwiftUIView() {
        let wordDetailView = WordDetail(word: word)
        let hostingController = UIHostingController(rootView: wordDetailView)
        
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
        
        view.backgroundColor = .systemBackground
        hostingController.view.backgroundColor = .clear
        
        hostingController.view.alpha = 0
        UIView.animate(withDuration: 0.2, delay: 0.05, options: .curveEaseOut) {
            hostingController.view.alpha = 1.0
        }
    }
}

// MARK: - Updated ContentView
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
    
    private var canGoBack: Bool {
        allWords.count > 1 && currentIndex > 0
    }
    
    var body: some View {
        ZStack {
            PageCurlView(
                allWords: $allWords,
                currentIndex: $currentIndex,
                onAddNewWord: addNewRandomWord
            )
            
            HStack {
                if canGoBack {
                    Button(action: goToPreviousWord) {
                        Label("Go to previous word", systemImage: "chevron.backward")
                            .labelStyle(.iconOnly)
                            .font(.system(size: 30))
                            .foregroundColor(.secondary)
                    }
                } else {
                    Color.clear
                        .frame(width: 30, height: 30)
                }
                
                Spacer()
                
                Button(action: goToNextWord) {
                    Label("Go to next word", systemImage: "chevron.forward")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 30))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Actions
    private func goToPreviousWord() {
        guard canGoBack else { return }
        currentIndex -= 1
    }
    
    private func goToNextWord() {
        if currentIndex < allWords.count - 1 {
            currentIndex += 1
        } else {
            addNewRandomWord()
            currentIndex += 1
        }
    }
    
    private func addNewRandomWord() {
        guard let newWord = modelData.words.randomElement() else { return }
        allWords.append(newWord)
    }
}

#Preview {
    ContentView()
}
