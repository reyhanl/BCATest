//
//  JSONReader.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/30.
//
import Foundation

struct JSONReader{
    let bundle: Bundle
    
    init(bundle: Bundle) {
        self.bundle = bundle
    }
    
    func generateDummyFromJSON<T: Codable>(fileName: String) throws -> T{
        let str = try JSONReader(bundle: bundle).readJSON(fileName: fileName)
        guard let data = str.data(using: .utf8) else{
            throw CustomError.custom("Failed to turn it into Data")
        }
        let json = try JSONDecoder().decode(T.self, from: data)
        return json
    }
    
    func readJSON(fileName: String) throws -> String{
        if let path = bundle.path(forResource: fileName, ofType: "json"){
            do{
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                // Convert the data back into a string
                if let text = String(data: data, encoding: .utf8) {
                    return text
                }else{
                    throw CustomError.custom("Failed to read file")
                }
            }
        }
        throw CustomError.fileNotFound
    }
    
}
