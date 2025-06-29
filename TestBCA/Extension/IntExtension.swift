//
//  IntExtension.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/29.
//
import Foundation

extension Int{
    var durationStr: String{
        let hour = self / 3600
        let minute = self % 3600 / 60
        let second = self % 3600 % 60
        
        let hourStr = String(format: "%02d", hour)
        let minuteStr = String(format: "%02d", minute)
        let secondStr = String(format: "%02d", second)
        
        if hour == 0{
            return "\(hourStr):\(minuteStr):\(secondStr)"
        }else{
            return "\(minuteStr):\(secondStr)"
        }
    }
}
