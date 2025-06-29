//
//  Audios.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/30.
//
import Foundation

@objc public class Audios: NSObject, NSCoding, Codable {
    
    public var audios: [Audio] = []

    enum Key: String {
        case audios = "audios"
    }

    public init(audios: [Audio]) {
        self.audios = audios
    }

    public func encode(with coder: NSCoder) {
        coder.encode(audios, forKey: Key.audios.rawValue)
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        guard let decodedAudios = aDecoder.decodeObject(forKey: Key.audios.rawValue) as? [Audio] else {
            return nil
        }
        self.init(audios: decodedAudios)
    }
}
