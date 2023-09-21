//
//  GameAlertView.swift
//  CoreML-demo
//
//  Created by Martin Regas on 18/09/2023.
//

import SwiftUI

struct GameAlertView: View {
    @EnvironmentObject var gameHelper: GameHelper
    
    var body: some View {
        VStack {
            VStack(spacing: 50) {
                VStack {
                    VStack(spacing: 20) {
                        
                        VStack(spacing: 10) {
                            Text("Score: \(gameHelper.score)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primaryBlack)

                            Divider()
                                .background(Color.darkBlue)
                            
                            Text("Best Score: \(gameHelper.bestScore)")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.primaryBlack)
                        }
                        
                        Button(action: {
                            gameHelper.startGame()
                            gameHelper.firstGame = false
                        }, label: {
                            Image("play-icon")
                        })
                        
                        Text(gameHelper.firstGame ? "PLAY" : "PLAY AGAIN")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.primaryBlack)
                    }
                }
                .padding(.vertical, 20)
            }
            .background(Color.background)
            .cornerRadius(14)
            .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background.opacity(0.5))
    }
}

struct GameAlertView_Previews: PreviewProvider {
    static var previews: some View {
        GameAlertView()
            .environmentObject(GameHelper())
    }
}
