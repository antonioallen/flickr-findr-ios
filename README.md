#  Flickr Findr

This app is a simple way to explore photos using the [Flickr API](https://www.flickr.com/services/api/)

## Requirements

- Xcode 10.0+
- Swift 4.0+
- [CocoaPods](https://cocoapods.org/)
- [SwiftLint](https://github.com/realm/SwiftLint)
- We running this project please use the `Flickr Finder.xcworkspace` file. Run `pod repo update` to update the pods.
- You may get an error if you don't have swift lint installed. Install it by running the following command `brew install swiftlint`

## Features

- Top trending photos of the day
- Search photos using the search bar
- Save prior search terms for quick reuse
- Clear recent search terms
- Zoom into photos to get a better view
- Infinite scrolling with simple cache management
- Unit tested with both unit and UI tests
- Coordinator pattern for navigation
- Abstracted networking interface for flexibility and testability.
- Multiple configurations setup
- Localized
- Swift Lint for consistent coding style and best practices

## Libraries Used
### [IGListKit](https://github.com/Instagram/IGListKit)
- IGListKit is the only library used in this project. The reason I chose to use this library is because of its diffing capabilities and abstraction to create flexible lists on the UICollectionView. This is the same library used in the Instagram App.

## Screenshots
<img src="https://github.com/antonioallen/flickr-findr-ios/blob/master/Screenshots/IMG_1850.PNG" align="left" height="812" width="375" >
<img src="https://github.com/antonioallen/flickr-findr-ios/blob/master/Screenshots/IMG_1851.PNG" align="left" height="812" width="375" >
<img src="https://github.com/antonioallen/flickr-findr-ios/blob/master/Screenshots/IMG_1852.PNG" align="left" height="812" width="375" >
<img src="https://github.com/antonioallen/flickr-findr-ios/blob/master/Screenshots/IMG_1853.PNG" align="left" height="812" width="375" >
