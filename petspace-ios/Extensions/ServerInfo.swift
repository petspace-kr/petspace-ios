//
//  ServerInfo.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/8/23.
//

import Foundation

enum ServerURLCollection: String {
    // 서버 API 주소
    case healthCheck = "https://petspace.whitekiwi.link:3000/health"
    case sendLog = "https://petspace.whitekiwi.link:3000/api-app/v1/logs"
    case getStoreList = "https://petspace.whitekiwi.link:3000/api-app/v1/list-items"
    case getStoreDetail = "https://petspace.whitekiwi.link:3000/api-app/v1/detail"
    
    // test url
    case getTestStoreList = "https://raw.githubusercontent.com/leehe228/SwiftCodingClass/main/dummydata.json"
}

// 서버에 로그를 기록하는 구조체
struct ServerLogger {
    
    static let urlString = ServerURLCollection.sendLog.rawValue

    static func sendLog(group: String, message: String) {
    
        // user Id 가져오기
        let userID = getUserID()
        var parameters = ["userId" : "\(userID)"]
        
        // Type
        parameters["type"] = "\(group)"
        
        // message
        parameters["message"] = "\(message)"
        
        // param
        parameters["params"] = "{\"id\":\"1\"}"
        
        // timestamp 가져오기
        let timestamp = getTimestamp()
        parameters["timestamp"] = "\(timestamp)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let postData = try? JSONSerialization.data(withJSONObject: parameters) {
            if let jsonString = String(data: postData, encoding: .utf8) {
                print("post Data: \(jsonString)")
                request.httpBody = jsonString.data(using: .utf8)
            }
        }
        
        print("log data created: \(parameters.description)")
        
        /* URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error while sending a log: \(error)")
                return
            }
            
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        print("Log data sended successfully: \(responseString)")
                    }
                }
            }
        }
        .resume() */
    }
    
    static func getTimestamp() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let formattedDateString = dateFormatter.string(from: currentDate)
        print("formatted: \(formattedDateString)")
        
        return formattedDateString
    }
    
    static func createUserID() -> String {
        
        let currentDate = Date()
        let userID = "USER\(currentDate.timeIntervalSince1970)".replacingOccurrences(of: ".", with: "")
        print("createUserID() - userID Created: \(userID)")
        
        UserDefaults.standard.set(userID, forKey: "userIDString")
        print("createUserID() - userID Saved")
        
        return userID
    }
    
    static func getUserID() -> String {
        let userID: String? = UserDefaults.standard.string(forKey: "userIDString")
        
        if let userID = userID {
            print("getUserID() - userID returned")
            return userID
        } else {
            // userID가 없다면 생성
            print("getUserID() - No UserID Found")
            let newUserID = createUserID()
            return newUserID
        }
    }
}
