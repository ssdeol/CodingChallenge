//
//  ServiceManager.swift
//  CodingChallenge
//
//  Created by Sukhpreet Deol on 2/9/18.
//  Copyright © 2018 Sukhpreet Deol. All rights reserved.
//

import Foundation
import SystemConfiguration
import Security


/// This class will be used to make any API request to the network. It will use the Generic Type to implemet the RequestObject Protocol. It will take all the information stored in the RequestObject and pass it on the Call and handle any errors made during that call. It is written in a way that changes to call making and error handling are not required for any kind of API call. All the changes would be made in the struct implementing the RequestObject and DecodeableResponse protocols.
class ServiceManager: NSObject {

    static let trackSearchURL = "https://itunes.apple.com/search?term=%@"
    static let lyricsSearchURL = "http://lyrics.wikia.com/api.php?func=getSong&artist=%@&song=%@&fmt=json"
    
    
    //MARK: Singleton Instance
    static let sharedInstance = ServiceManager()
    
    //MARK:- Declare Error
    fileprivate var serverError:String? = "Cannot establish secure connection with App and Server, please try later."
    
    
    
    //MARK:- URL Request/Response
    func send<T:RequestObject>(_ r:T,completion:@escaping CompletetionBlock<T>) {
        let url = r.url
        var request = URLRequest(url: url)
        request.httpMethod = r.method
        request.timeoutInterval = 10
        if r.header != nil{
            for header in r.header! {
                let key = header.keys.first
                request.setValue(header[key!] as? String, forHTTPHeaderField: key!)
            }
        }
        if r.body != nil {
            let bodyData = try! JSONSerialization.data(withJSONObject: r.body!, options: .prettyPrinted)
            var bodyStr = String(data: bodyData, encoding: .utf8)
            bodyStr = bodyStr?.replacingOccurrences(of: "\\", with: "")
            request.httpBody = bodyStr!.data(using: .utf8)!
        }
        let config = URLSessionConfiguration.default
        let session = URLSession.init(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(false, nil, .Normal(error!.localizedDescription))
                return
            }
            guard response is HTTPURLResponse else{
                assert(false, "Response is not http response")
                completion(false, nil, .Unknown)
                return
            }
            guard (response as! HTTPURLResponse).statusCode != 404 else {
                assert(false, "404 NOT FOUND")
                completion(false, nil, .Normal("System Unavailable"))
                return
            }
            
            guard (response as! HTTPURLResponse).statusCode != 400 else {
                completion(false,nil,.Normal("Bad Request"))
                return
            }
            guard data != nil else {
                assert(false, "Response body is empty")
                completion(false, nil, .Unknown)
                return
            }
            guard (response as! HTTPURLResponse).statusCode == 200 else {
                let res = T.response.parse(data: data!, success: false)
                completion(false, res, nil)
                return
            }
            let res = T.response.parse(data: data!, success: true)
            guard res != nil else {
                assert(false, "Invalid Json Response")
                completion(false, nil, .Normal("System Unavailable"))
                return
            }
            completion(true, res, nil)
        }
        task.resume()
    }
    
    /// Makes the API call for getting the Track Information.
    /// - Parameters:
    ///   - searchTerm: searchTerm that is inputted in the searchBar.
    ///   - completion: Result which will be passed back as a result of this API call.
    func getTracks(searchTerm: String, completion:@escaping CompletetionBlock<TrackAPIRequest>) {
        let searchTerm = searchTerm.replacingOccurrences(of: " ", with: "+")
        let url = String(format: ServiceManager.trackSearchURL, searchTerm)
        let request = TrackAPIRequest(url: url, method: "GET")
        send(request, completion: completion)
    }
    
    /// This function will make the API call for getting the Lyrics Information.
    /// - Parameters:
    ///   - artistName: Artist Name to be added to the URL.
    ///   - songName: Song Name to be added to the URL
    ///   - completion: Result which will be passed back as a result of this API call.
    func getTrackLyrics(artistName: String, songName: String, completion:@escaping CompletetionBlock<LyricsAPIRequest>){
        let artistName = artistName.replacingOccurrences(of: " ", with: "+")
        let songName = songName.replacingOccurrences(of: " ", with: "+")
        let url = String(format: ServiceManager.lyricsSearchURL, artistName, songName)
        let request = LyricsAPIRequest(url: url, method: "GET")
        send(request, completion: completion)
    }

}

enum ErrorType:Error {
    case Unknown
    case Normal(String)
}


