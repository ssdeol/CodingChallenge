# CodingChallenge
iOS App for searching music and lyrics. 

Requirements
	•	Language: Swift 4.0
	•	Runtime: iOS: 11.0+
	•	IDE: XCode: 9.2
	•	macOS: Sierra (10.13.2)

Description:

This application is for a code challenge for a job interview. The primary function is that the user can search for music related information. The user will type in a search term and press the “Search” button on the keyboard which will trigger the search and return the track's information associated with that term. Then the user can click on the song of his/her choosing and get details about that song and see it’s lyrics.

Tech Detail:

Used apple default MVC pattern. Application start at Main.storyboard. “TrackViewController” is the first view controller where the user will find an empty screen with a search bar. If the user enters a search term and presses enter then an API call is made to the “iTunes” api and the results are displayed in a tableView. In any row, the user can see the track name, artist name, album name and the album art associated with that track. If any of the information is missing, a default string “Could not be found” is displayed. There the user has the ability to click on any track in that list which will take them to the “LyricsViewController”. 

In LyricsViewController, the user will again see the information about the track on the very top and the song’s lyrics in the textView below. The lyrics information is gotten from another API called the “Lyrics.wikia”. If there are lyrics available associated with the track selected, then those lyrics will be displayed. Otherwise “Not found” will be populated in the textView. 

Other things to note about this app other than the functionality. While the API call is being made and the results are being queried, an activityIndicator will be shown to the user to let them know that the app is searching.

A thing that stands out about the code of this app is that JSONSerialization is  used alongside the JSONDecoder. The reason for that is that the response from the API is formatted in an a weird format. It is not in JSON format so in order to forcefully convert it to JSON, it is converted from Data to String type so we can control the string in a way where we can convert it to JSON format. Then it is converted back to Data type before the decoder is used. Both APIs have weird format responses so crude methods were used to solve the issue. This was done because the coding challenge’s description read in a way that it was implied that the developer had to handle the response in JSON format.

References
	•	Code Challenge - Music Search.pdf
	•	Itunes API: https://itunes.apple.com/search?term
	•	Lyrics API: http://lyrics.wikia.com/api.php?func=getSong&artist=Tom+Waits&song=new+coat+of+paint&fmt=json 
	•	SDWebImage: https://github.com/rs/SDWebImage
	•	NVActivityIndicatorView: https://github.com/ninjaprox/NVActivityIndicatorView
	

