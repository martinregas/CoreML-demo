//
//  Sounds.swift
//  CoreML-demo
//
//  Created by Martin Regas on 17/09/2023.
//

import Foundation

enum Sounds {
    case error
    case pencil
    case success
    case erase
    case clock
    case gameOver
    case next
    
    static var all: [Sounds] = [.error, .pencil, .success, .erase, .clock, .gameOver, .next]
    
    var fullName: String {
        return "\(fileName).\(fileExtension)"
    }
    
    var fileName: String {
        switch self {
        case .error: return "error"
        case .pencil: return "pencil"
        case .success: return "success"
        case .erase: return "erase"
        case .clock: return "clock"
        case .gameOver: return "game-over"
        case .next: return "next"
        }
    }
    
    var fileExtension: String {
        return "wav"
    }
}
