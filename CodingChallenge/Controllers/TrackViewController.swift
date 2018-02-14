//
//  TrackViewController.swift
//  CodingChallenge
//
//  Created by Sukhpreet Deol on 2/9/18.
//  Copyright © 2018 Sukhpreet Deol. All rights reserved.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

class TrackViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let serviceManager = ServiceManager.sharedInstance
    var searchTerm: String = ""
    
    /// trackArray - An array to store the objects returned from the API Call.
    var trackArray: [Track] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Track Details"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /* This function will trigger once the "search" button on the keyboard
        is pressed. It will take the text in the search bar and store in the
        searchTerm variable and call the fetchSearchTerm.
        NVActivityIndicatorPresenter, is a pod, which will show the progress bar
        as the API is being called and the data is being loaded.
     */
    /// - Parameter searchBar: The text from the searchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTerm = searchBar.text ?? ""
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(type: .pacman))
        fetchSearchTerms()
    }
    

    /* This function will call the API through the Service Manager class. The
     search term will be passed on the function getTracks() and the API will call.
     The result from the API, if it is a success, will be returned in the response
     variable trackArray which is of type [Track] and it will populate the local array
     so the tableView could be populated with the data returned when reloadData() is called.
     NVActivityIndicatorPresenter will stop showing the progress bar.
    */
    func fetchSearchTerms() {
        view.endEditing(true)
        serviceManager.getTracks(searchTerm: searchTerm) { (isSuccess, response, error) in
            guard isSuccess else {
                /// SHOW error message
                return
            }
            self.trackArray = response?.trackArray ?? []
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            self.tableView.reloadData()
        }
    }
}

extension TrackViewController: UITableViewDataSource, UITableViewDelegate {
    /// Number of rows based on how many elements are in the trackArray.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackArray.count
    }
    
    /// Populate the TableView with the information stored in the trackArray.
    /// Parameters:
    /// imageURL - This variable will hold the URL for where the image is supposed to be downloaded from.
    /// sd_setImage - It is a pod, it will go to the URL and download the image and if the image is not there, it will populate the local imageView with a placeholder which is stored in the local Assets folder.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackInfoCell", for: indexPath) as! TrackInfoTableViewCell
        let imageURL = URL(string: trackArray[indexPath.row].trackAlbumArt)
        cell.trackNameLabel.text = trackArray[indexPath.row].trackName
        cell.trackArtistLabel.text = trackArray[indexPath.row].trackArtistName
        cell.trackAlbumLabel.text = trackArray[indexPath.row].trackAlbumName
        cell.trackAlbumArtImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder"))
        return cell
    }
    
    /// After a table row is clicked, it will see which row is clicked and go to the next controller with the information about that track so another API could be called to get the lyrics.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "lyricsVC") as! LyricsViewController
        controller.track = trackArray[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /// Height for each row.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
