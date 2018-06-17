# MovieFinder
### The application
The MovieFinder application is an application which is capable of looking for movies in the TMDB database.

### Installation guide
To be able to run and install the application, you need to fulfill the following requirements:
- Xcode 9.4 or higher
- carthage 0.29.0 or higher

##### Step 1
Clone the repository by typing in the command line:
```
$ git clone git@github.com:dalu93/MovieFinder.git
```
##### Step 2
Enter in the newly created folder and run `carthage`
```
$ carthage update --platform iOS
```
##### Step 3
Open the `MovieFinder.xcodeproj` file using Xcode and run the project

### Design decisions
##### Architecture
The application architecture is **MVVM**, with usage of *Services*, *Stores* and *FlowControllers* 
for connecting to the API, persistance and navigation.
Every object, which is being stored in the database, has his own *Entity* instance which is only
used to communicate with the database layer. In this way any error and inconsistency should
be avoided.

##### Usage of SwiftLint
I have decided to use SwiftLint (version 0.25.1) with default rules to make sure that the 
code is clean and readable for the iOS/Swift community members. Only one warning couldn't be
solved in a clean way, so I decided to leave it unsolved. Below the line:
```swift
private(set) var searchStatus: Bindable<ConnectionStatus<APIService.RequestType, SearchResult>> = Bindable(.notStarted)
```
##### Usage of libraries
Some of the objects related to API communication and other useful extensions are taken from
my own [SwiftHelpSet](https://github.com/dalu93/SwiftHelpSet) repository.
The other libraries I have used are:
- Quick & Nimble - for testing purpose
- OHHTTPStubs - for testing purpose
- realm-cocoa - for persistance
- Toaster - for showing quick error messages to the user
- SwiftyBeaver - for logging purpose
- Kingfisher - for asynchronous download of images

I decided to not use any library as RxSwift because I consider this as a very small project
which doesn't need such a huge framework behind. By using the simple `Bindable`,
`ConnectionStatus` and `Completion` I have been able to reach the same quality of code, 
in my opinion.



