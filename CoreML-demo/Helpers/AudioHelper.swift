//
//  AudioHelper.swift
//  CoreML-demo
//
//  Created by Martin Regas on 17/09/2023.
//

import AVFoundation

class AudioHelper {
    private var players = [AVAudioPlayer]()
    
    init () {
        for sound in Sounds.all {
            guard let url = Bundle.main.url(forResource: sound.fileName, withExtension: sound.fileExtension) else {
                continue
            }
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                players.append(player)
            }
            catch {
                print(error)
            }
        }
    }
    
    func play(sound: Sounds, stopBefore: Bool = false) {
        if stopBefore {
            stop(sound: sound)
        }
        guard let player = players.first(where:{$0.url?.lastPathComponent == sound.fullName}), !player.isPlaying  else { return }
        player.play()
    }
    
    func stop(sound: Sounds) {
        guard let player = players.first(where: {$0.url?.lastPathComponent == "\(sound.fileName).\(sound.fileExtension)"} ) else { return }
        player.stop()
        player.currentTime = 0
    }
}


