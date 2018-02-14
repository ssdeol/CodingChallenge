//
//  TrackModel.swift
//  CodingChallenge
//
//  Created by Sukhpreet Deol on 2/9/18.
//  Copyright © 2018 Sukhpreet Deol. All rights reserved.
//

import Foundation


/// This is the model for Track. It will have 3 fields: trackName: - Song Name, trackArtistName - Artist Name and trackAlbumName - Song Album, trackAlbumArt - Album art. This class implements the Codable protocol. Which is used to call the JSONDecoder. JSONDecoder will automatically parse the data returned from the API call for the feilds specified in the TrackKeys and initialize the Track Model with that data. Because we are only using the 'GET' call, we only need to decode the incoming data so only the decoder func is being used.
class Track: NSObject, Codable {
    
    var trackName: String = ""
    var trackArtistName: String = ""
    var trackAlbumName: String = ""
    var trackAlbumArt: String = ""
    
    enum TrackKeys: String, CodingKey {
        case apiTrackName = "trackName"
        case apiTrackArtistName = "artistName"
        case apiTrackAlbumName = "collectionName"
        case apiTrackAlbumArt = "artworkUrl100"
    }
    
    
    ///  This func will take the keyfields from the data returned and initalize the Track Model with it. Track model will be initalized with the data returned but if no such field is found in the response we will store something ourselves to make sure that the App does not crash due to nil values.
    /// - Parameter decoder: Will have the Decoder to decode parse the data returned.
    convenience required init(from decoder: Decoder){
        self.init()
        
        let container = try! decoder.container(keyedBy: TrackKeys.self)
        self.trackName = (try? container.decode(String.self, forKey: .apiTrackName)) ?? "Track Name could not be found"
        self.trackArtistName = (try? container.decode(String.self, forKey: .apiTrackArtistName)) ?? "Track Artist could not be found"
        self.trackAlbumName = (try? container.decode(String.self, forKey: .apiTrackAlbumName)) ?? "Track Album could not be found"
        self.trackAlbumArt = (try? container.decode(String.self, forKey: .apiTrackAlbumArt)) ?? "Track Album Art could not be found"
    }
    
    func encode(to encoder: Encoder) {
        
    }
}


/// This Struct will implement the RequestObject class so ServiceManager.send() func could be called because it requires a requestObject type. For RequestObject to work, we also need to implement a DecodableRespone which is defined in the TrackAPIResponse struct.
struct TrackAPIRequest: RequestObject {
    typealias response = TrackAPIResponse
    
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

/// When the ServiceManager API is called, it will store the result in the DecodableResponse and here  we will get the data and parse/control it as we like and return it in the response for the API Call. The data will be manipuated in this struct to meet our requirements.
struct TrackAPIResponse: DecodableResponse {
    
    var error: ErrorType?
    var trackArray: [Track] = []
    
    static func parse(data: Data, success: Bool) -> TrackAPIResponse? {
        var response = TrackAPIResponse()

        if success {
            guard let responseDict = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]) else { return response }
            guard let results = responseDict["results"] as? [Any] else { return response }
            guard let resultData = try? JSONSerialization.data(withJSONObject: results, options: .prettyPrinted) else { return response }
            guard let tracks = try? JSONDecoder().decode([Track].self, from: resultData) else { return response }
            
            response.trackArray = tracks
            return response
        } else {
            response.error = ErrorType.Normal("Bad Request")
            return response
        }
    }
}
