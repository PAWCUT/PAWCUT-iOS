//
//  AudioManager.swift
//  PawCut
//
//  Created by Luminouxx on 8/21/25.
//

import Foundation
import AVFoundation

final class AudioManager: NSObject, ObservableObject {
    private var audioPlayer: AVAudioPlayer?
    
    @Published var isPlaying: Bool = false
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // TODO: 오디오 세션 설정 실패 처리
        }
    }
    
    func playAudio(audioFile: AudioFile) {
        
        guard let url = Bundle.main.url(forResource: audioFile.rawValue, withExtension: "mp3") else {
            // TODO: 예외 처리 - 파일이 존재하지 않는 경우
            return
        }
        
        do {
            stopAudio()
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            
            let success = audioPlayer?.play() ?? false
            isPlaying = success
        } catch {
            // TODO: 예외 처리 - 오디오 플레이어 생성 실패
        }
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
    }
    
    func setVolume(_ volume: Float) {
        audioPlayer?.volume = max(0.0, min(1.0, volume))
    }
}

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        // TODO: 예외 처리 - 재생 완료 후 추가 작업
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        isPlaying = false
        // TODO: 예외 처리 -디코딩 오류 처리
    }
}
