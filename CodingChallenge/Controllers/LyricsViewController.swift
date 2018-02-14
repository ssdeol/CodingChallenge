//
//  LyricsViewController.swift
//  CodingChallenge
//
//  Created by Sukhpreet Deol on 2/9/18.
//  Copyright © 2018 Sukhpreet Deol. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class LyricsViewController: UIViewController {

    @IBOutlet weak var albumArtImage: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var lyricsTextView: UITextView!
    
    var track: Track!
    var lyrics: Lyrics!
    let serviceManager = ServiceManager.sharedInstance
    
    /* This function will be called before the screen shows up, it will call the local API function
        and populate the UIViews with the data that is available. 
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Track Lyrics"
        self.fetchLyrics()
        self.reloadView()
    }
    
    /* This function will call the API through the Service Manager class. It will take the artist and
     song name stored in the "track" variable which is set in the previous controller and  pass it
     on the function getTrackLyrics() and the API will call.
     The result from the API, if it is a success, will be returned in the response
     variable lyrics which is of type "Lyrics" and it will populate the local "lyrics" variable
     so the row and textView could be populated with the data returned when reloadView() is called.
     NVActivityIndicatorPresenter will start showing the progress bar.
     */
    func fetchLyrics() {
        view.endEditing(true)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: .pacman))
        serviceManager.getTrackLyrics(artistName: track.trackArtistName, songName: track.trackName) { (isSuccess, response, error) in
            guard isSuccess else {
                /// SHOW error message
                return
            }
            self.lyrics = response?.lyrics
            self.reloadView()
        }
    }
    
    /// This function will be called to populate the UIViews with the data stored in the "track" and "lyrics" variable
    /// Parameters:
    /// imageURL - This variable will hold the URL for where the image is supposed to be downloaded from.
    /// sd_setImage - It is a pod, it will go to the URL and download the image and if the image is not there, it will populate the local imageView with a placeholder which is stored in the local Assets folder.
    func reloadView() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        let imageURL = URL(string: (track?.trackAlbumArt)!)
        trackNameLabel.text = track?.trackName ?? ""
        artistNameLabel.text = track?.trackArtistName ?? ""
        albumNameLabel.text = track?.trackAlbumName ?? ""
        albumArtImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"))
        lyricsTextView.text = lyrics?.songLyrics.replacingOccurrences(of: "\"", with: "'") ?? ""
    }
}
