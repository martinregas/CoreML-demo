//
//  ContentView.swift
//  CoreML-demo
//
//  Created by Martin Regas on 15/09/2023.
//

import SwiftUI

struct Line {
    var points = [CGPoint]()
}

struct ContentView: View {
    @EnvironmentObject var gameHelper: GameHelper
    
    @State private var currentLine = Line()
    @State private var lines: [Line] = []
        
    @State private var boardSize: CGSize = .zero
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Image("logo")
                
                HStack(spacing: 100) {
                    HStack {
                        Text("SCORE: ")
                            .font(.system(size: 16, weight: .bold))
                        +
                        Text("\(gameHelper.score)")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack{
                        Text("TIME: ")
                            .font(.system(size: 16, weight: .bold))
                        +
                        Text("\(gameHelper.timeRemaining)")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .foregroundColor(.primaryBlack)
                
                if let currentWord = gameHelper.currentWord {
                    Text(currentWord.capitalized)
                        .font(.system(size: 32, weight: .medium))
                        .frame(height: 20, alignment: .center)
                        .foregroundColor(.primaryBlack)
                }
                
                board
                
                HStack(alignment: .center, spacing: 40) {
                    Button(action: {
                        clearBoard()
                        gameHelper.playSound(sound: .erase)
                    }, label: {
                        VStack(spacing: 0) {
                            Image("clear-btn")
                            Text("Clear")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primaryBlack)
                        }
                    })
                    
                    Button(action: {
                        if checkBoard() {
                            gameHelper.classifyImage(image: board.snapshot(size: boardSize))
                        }
                    }, label: {
                        Text("Check")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    })
                    .frame(width: 88, height: 44)
                    .background(Color.darkBlue)
                    .cornerRadius(10)
                    
                    Button(action: {
                        gameHelper.nextWord()
                        gameHelper.playSound(sound: .next)
                    }, label: {
                        VStack(spacing: 0) {
                            Image("skip-btn")
                            Text("Skip")
                                .font(.system(size: 16, weight: .medium))
                        }
                    })
                }
                .foregroundColor(.primaryBlack)
            }
            .padding(16)
            .background(Color.background)
            
            if gameHelper.showAlert {
                gameAlertView
            }
        }
        .onChange(of: gameHelper.currentIndex) { _ in
            clearBoard()
        }
        .onChange(of: gameHelper.showAlert) { _ in
            clearBoard()
        }
        .onReceive(gameHelper.clearBoard) {
            
        }
    }
    
    var board: some View {
        GeometryReader { geo in
            VStack {
                Canvas { context, size in
                    for line in lines {
                        var path = Path()
                        path.addLines(line.points)
                        context.stroke(path, with: .color(.primaryBlack), lineWidth: 1)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                .background(.white)
                .cornerRadius(8)
                .onAppear {
                    boardSize = geo.size
                }
                .onChange(of: geo.size) { newSize in
                    boardSize = newSize
                }
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ value in
                            let newPoint = value.location
                            if currentLine.points.isEmpty || currentLine.points.first! != newPoint {
                                gameHelper.playSound(sound: .pencil)
                                currentLine.points.append(newPoint)
                                lines.append(currentLine)
                            }
                        })
                        .onEnded({ _ in
                            gameHelper.stopSound(sound: .pencil)
                            lines.append(currentLine)
                            currentLine = Line(points: [])
                        })
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    var gameAlertView: some View {
        GameAlertView()
            .environmentObject(gameHelper)
    }
    
    func clearBoard() {
        lines.removeAll()
    }
    
    func checkBoard() -> Bool {
        if lines.isEmpty {
            gameHelper.playSound(sound: .error)
            return false
        }
        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(GameHelper())
    }
}
