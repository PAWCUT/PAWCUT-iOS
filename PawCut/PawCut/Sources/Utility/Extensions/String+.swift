//
//  String+.swift
//  PawCut
//
//  Created by taeni on 8/26/25.
//

extension String {
    
    // 마지막 글자가 한글인가?
    private var isLastCharacterHangul: Bool {
        guard let last = self.unicodeScalars.last else { return false }
        return (0xAC00...0xD7A3).contains(last.value)
    }
    
    // 마지막 글자에 받침이 있는가?
    private var hasFinalConsonant: Bool {
        guard let last = self.unicodeScalars.last else { return false }
        let value = last.value
        if value >= 0xAC00 && value <= 0xD7A3 {
            let jong = (value - 0xAC00) % 28
            return jong != 0
        }
        return false
    }
    
    private var jongSung: UInt32? {
        guard let last = self.unicodeScalars.last else { return nil }
        let value = last.value
        if value >= 0xAC00 && value <= 0xD7A3 {
            return (value - 0xAC00) % 28
        }
        return nil
    }
    
    
    var withComleteWordByJongsung: String {
        if isLastCharacterHangul {
            return hasFinalConsonant ? "\(self)이와" : "\(self)와"
        } else {
            return "\(self)(이)가"
        }
    }
}
