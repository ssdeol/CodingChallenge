//
//  LyricsModel.swift
//  CodingChallenge
//
//  Created by Sukhpreet Deol on 2/10/18.
//  Copyright © 2018 Sukhpreet Deol. All rights reserved.
//

import Foundation

/// This is the model for Lyrics. It will have 3 fields: name: - Song Name, artistName - Artist Name and songLyrics - Song Lyrics. This class implements the Codable protocol. Which is used to call the JSONDecoder. JSONDecoder will automatically parse the data returned from the API call for the feilds specified in the LyricsKeys and initialize the Lyrics Model with that data. Because we are only using the 'GET' call, we only need to decode the incoming data so only the decoder func is being used.
class Lyrics: NSObject, Codable {
    
    var name: String = ""
    var artistName: String = ""
    var songLyrics: String = ""
    
    enum LyricsKeys: String, CodingKey {
        case apiName = "song"
        case apiArtistName = "artist"
        case apiSongLyrics = "lyrics"
    }
    
    ///  This func will take the keyfields from the data returned and initalize the lyrics Model with it. Lyrics model will be initalized with the data returned but if no such field is found in the response we will store something ourselves to make sure that the App does not crash due to nil values.
    /// - Parameter decoder: Will have the Decoder to decode parse the data returned.
    convenience required init(from decoder: Decoder){
        self.init()
        
        let container = try! decoder.container(keyedBy: LyricsKeys.self)
        self.name = (try? container.decode(String.self, forKey: .apiName)) ?? "Song could not be found"
        self.artistName = (try? container.decode(String.self, forKey: .apiArtistName)) ?? "Song Artist could not be found"
        self.songLyrics = (try? container.decode(String.self, forKey: .apiSongLyrics)) ?? "Lyrics could not be found"
    }
    
    func encode(to encoder: Encoder) {}
}



/// This Struct will implement the RequestObject class so ServiceManager.send() func could be called because it requires a requestObject type. For RequestObject to work, we also need to implement a DecodableRespone which is defined in the LyricsAPIResponse struct.
struct LyricsAPIRequest: RequestObject {
    typealias response = LyricsAPIResponse
    
    var url: URL
    var method: String
    var header:[[String:Any]]?
    var body:[String:Any]?
    
    init(url: String, method: String) {
        let encodedFromat = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        self.url = URL.init(string: encodedFromat!)!
        print(self.url)
        self.method = method
        header = nil
    }
}

/// When the ServiceManager API is called, it will store the result in the DecodableResponse and here we will get the data and parse/control it as we like and return it in the response for the API Call. The data will be manipuated in this struct to meet our requirements.
struct LyricsAPIResponse: DecodableResponse {
    
    var error: ErrorType?
    var lyrics: Lyrics = Lyrics()
    
    static func parse(data: Data, success: Bool) -> LyricsAPIResponse? {
        var response = LyricsAPIResponse()
        
        if success {
            guard var jsonString = String.init(data: data, encoding: .utf8) else { return response }
            jsonString = jsonString.replacingOccurrences(of: "song = ", with: "")
            jsonString = jsonString.replacingOccurrences(of: "'", with: "\"")
            jsonString = jsonString.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let validJosnData = jsonString.data(using: .utf8) else { return response }
            guard let lyrics = try? JSONDecoder().decode(Lyrics.self, from: validJosnData) else { return response }
            
            response.lyrics = lyrics
            return response
        } else {
            response.error = ErrorType.Normal("Bad Request")
            return response
        }
    }
}

