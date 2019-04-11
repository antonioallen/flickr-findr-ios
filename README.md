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

## Future Enhancement / Improvements
The initial version of this application was to demonstrate foundational concepts when building an iOS Application. As such, there are of course many improvements to make. Here I highlight some of those improvements.

- Use image cache library such as Kingfisher for enhanced image caching and downloading capabilities.
- Look into using OperationQueues for more fine grain control over multithreading operations and to consolidate, organize, and reduce the number of threads that are created.
- Profile entire application regularly to understand how it is performing at different releases
- Add in superior reachability support for network connectivity issues.
- Allow users to download or share images.
- Rework `DetailViewController` for a more optimal zooming experience and improve the UX by allowing users to swipe between photos.
- Possibly use Twitter API to see trending tags or searches instead of having a hardcoded dataset of 3. 

## Screenshots
<img src="https://github.com/antonioallen/flickr-findr-ios/blob/master/Screenshots/IMG_1850.PNG" align="left" height="812" width="375" >
<img src="https://github.com/antonioallen/flickr-findr-ios/blob/master/Screenshots/IMG_1851.PNG" align="left" height="812" width="375" >
<img src="https://github.com/antonioallen/flickr-findr-ios/blob/master/Screenshots/IMG_1852.PNG" align="left" height="812" width="375" >
<img src="https://github.com/antonioallen/flickr-findr-ios/blob/master/Screenshots/IMG_1853.PNG" align="left" height="812" width="375" >

## Profiling

### Core Animations
