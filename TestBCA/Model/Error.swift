//
//  Error.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//

enum CustomError: Error{
    case custom(String)
    case failedToLoadContext
    case failedToLoadEntity
    case fileNotFound
    case noDataAvailable
    case searchError
    case failedToGoToNextAudio
    case failedToGoToPreviousAudio
    
    var friendlyMessage: String {
        switch self {
        case .custom(let string):
            return string
        case .failedToLoadContext:
            return "Mesin Penyimpanan Lagi Gangguan 😔"
        case .failedToLoadEntity:
            return "Mesin Penyimpanan Lagi Gangguan 😔"
        case .fileNotFound:
            return "Dimana kamu file, kok tidak ada 🥹"
        case .noDataAvailable:
            return "Eits, kosong 🙏🏻"
        case .searchError:
            return "Mohon Maaf Sistem Nya Ganggu Dulu 🙏🏻"
        case .failedToGoToNextAudio:
            return "Ga ada next next an Bang 🙏🏻"
        case .failedToGoToPreviousAudio:
            return "Baru juga mulai, dah mau kembali aja 🏃🏻"
        }
    }
}
