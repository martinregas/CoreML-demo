//
//  GameHelper.swift
//  CoreML-demo
//
//  Created by Martin Regas on 15/09/2023.
//

import UIKit
import SwiftUI
import CoreML
import Combine

class GameHelper: ObservableObject {
    @AppStorage("BestScore") var bestScore: Int = 0
    
    @Published var score: Int = 0
    @Published var currentIndex: Int = 0
    @Published var timeRemaining: Int = 60
    @Published var words: [String] = []
    @Published var showAlert: Bool = true
    @Published var firstGame: Bool = true
        
    private var cancellable: AnyCancellable?
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let audioHelper = AudioHelper()
    
    var clearBoard: AnyPublisher<Void, Never>
    
    init() {
        clearBoard = search
             .map { _ in () }
             .receive(on: DispatchQueue.main)
             .eraseToAnyPublisher()
    }
    
    func playSound(sound: Sounds) {
        audioHelper.play(sound: sound)
    }
    
    func stopSound(sound: Sounds) {
        audioHelper.stop(sound: sound)
    }
    
    let model: DrawingModel = {
        do {
            let config = MLModelConfiguration()
            return try DrawingModel(configuration: config)
        } catch {
            print(error)
            fatalError("Couldn't create Model")
        }
    }()
    
    var currentWord: String? {
        return words[currentIndex]
    }
    
    func startGame() {
        showAlert = false
        firstGame = false
        timeRemaining = 60
        score = 0
        currentIndex = 0
        words.removeAll()
        words = getLabels()
        cancellable = timer.sink { [weak self] _ in
            guard let self = self else { return }
          
            self.timeRemaining -= 1
            
            if self.timeRemaining <= 5 && self.timeRemaining > 0 {
                audioHelper.play(sound: .clock)
            }
            else if self.timeRemaining <= 0 {
                self.finishGame()
            }
        }
    }
    
    func getLabels() -> [String] {
        if let labels = model.model.modelDescription.classLabels as? [String] {
            return labels.shuffled()
        }
        return []
    }
    
    func classifyImage(image: UIImage) {
        guard let buffer = image.convertToBuffer() else {
            audioHelper.play(sound: .error)
            return
        }
        
        let output = try? model.prediction(image: buffer)
        
        if let output = output {
            let results = output.classLabelProbs.sorted { $0.1 > $1.1 }
            
//            let result = results.map { (key, value) in
//                return "\(key) = \(String(format: "%.2f", value * 100))%"
//            }.joined(separator: "\n")
            print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
            for result in results.prefix(10) {
                print(result)
            }
            
            checkWord(results: results)
        }
    }
    
    func checkWord(results: [Dictionary<String, Double>.Element]) {
        for result in results.prefix(10) {
            if let word = currentWord, word == result.key, result.value > 0 {
                audioHelper.play(sound: .success, stopBefore: true)
                score += 1
                nextWord()
                return
            }
        }
        audioHelper.play(sound: .error)
    }
    
    func finishGame() {
        showAlert = true
        audioHelper.play(sound: .gameOver)
        timer.upstream.connect().cancel()
        if score > bestScore {
            bestScore = score
        }
    }
    
    func nextWord() {
        currentIndex += 1
        if currentWord == nil {
            finishGame()
        }
    }
}

