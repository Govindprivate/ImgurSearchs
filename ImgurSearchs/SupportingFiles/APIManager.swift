//
//  APIManager.swift
//  ImgurSearchs
//
//  Created by Govind Kumar on 15/06/23.
//

import Foundation
import Alamofire

struct URLS{
    // API Url for searching image "Top" in this "Week" and "q" is searching string
    public static let SEARCH_IMAGE = "https://api.imgur.com/3/gallery/search/top/week/0"
}

public class APIManager: NSObject {
    public static let session = Session(eventMonitors: [ AlamofireLogger() ])
    
    static let headers: HTTPHeaders = [
        "Content-Type" : "application/json",
        "Accept" : "*/*",
        "Authorization" : "Client-ID de6b0e4c29b7718"
    ]
    
    
    //MARK: Get Images
    public static func getImagesForSearch(text: String) -> DataRequest{
        
        let parameters: [String: String] = [
            "q": text
        ]
        return session.request(URLS.SEARCH_IMAGE, method:.get, parameters:parameters, encoding: URLEncoding.queryString , headers: headers)
    }
}

// Class to Log Request Response
final class AlamofireLogger: EventMonitor {
    
    func requestDidResume(_ request: Request) {
        
        let allHeaders = request.request.flatMap { $0.allHTTPHeaderFields.map { $0.description } } ?? Constant.Message.noneString
        let headers = """
        *************************************************************
        Request Started: \(request)
        Headers: \(allHeaders)
        *************************************************************
        """
        print(headers)
        
        
        let body = request.request.flatMap { $0.httpBody.map { String(decoding: $0, as: UTF8.self) } } ?? Constant.Message.noneString
        let message = """
        *************************************************************
        Request Started: \(request)
        Body: \(body)
        *************************************************************
        """
        print(message)
    }
    
    
    func request<Value>(_ request: DataRequest, didParseResponse response: AFDataResponse<Value>) {
        let message = """
        *************************************************************
        Response Received: \(response.debugDescription)
        Response All Headers: \(String(describing: response.response?.allHeaderFields))
        *************************************************************
        """
        print(message)
    }
}



