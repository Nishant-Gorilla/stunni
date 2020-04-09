//
//  Utilities.swift
//  Stunii
//
//  Created by Uday Bhateja on 23/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

class Utilities {
    
    class func readFile(_ res: String, ofType type: String) -> [String] {
        var array: [String] = []
        guard let filePath = Bundle.main.path(forResource: res, ofType: type) else {
            return array
        }
        do {
            let contents = try String(contentsOfFile: filePath)
            array = contents.components(separatedBy: "\r\n")
        }
        catch {}
        return array
    }
    
    class func openUrlInSafari(string: String) {
        if let url = URL(string: string), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    class func yearsBetweenDate(startDate: Date, endDate: Date) -> Int {

        let calendar = Calendar.current

        let components = calendar.dateComponents([.year], from: startDate, to: endDate)

        return components.year!
    }
    class func convertStringToDate(_ date: String) -> Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.date(from: date) ?? Date()
    }

    
}
