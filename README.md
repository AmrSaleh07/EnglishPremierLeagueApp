# Premier League App

Premier League App is a sample iOS app that displays information about the English Premier League. The app has two screens: Fixtures List and Favorites List.

## Technical Stack
The app is built using the following technologies:

* SwiftUI: A modern declarative framework for building user interfaces.
* Combine: A functional reactive programming framework for handling asynchronous events.
* Async/Await: A new concurrency model for Swift that simplifies the handling of asynchronous code.
* Moya: A networking abstraction layer that makes it easier to write network code.

## Features
The app has the following features:

### Fixtures List
The screen has the following requirements:

1. Each item displays the teams’ names and the game result or the time of the game in hh:mm (if it’s not played yet).
2. The list is sectioned by day.
3. The first visible section of the list has to be the current day or the next if the current day has no fixtures.
4. Provide a control toggle between showing:
    * The entire list.
    * Mark a fixture as “favorite”.
    * A subset of the list, containing only those favorite fixtures.

### Favorites List
The Favorites List screen displays a list of favorite fixtures selected by the user on the Fixtures List screen. The screen has the following requirements:
1. The list displays all favorite fixtures.
2. The list is sorted by date (newest first).
3. Each item displays the teams’ names and the game result or the time of the game in hh:mm (if it’s not played yet).
4. Provide a control toggle between showing:
    * The entire list.
    * A subset of the list, containing only those favorite fixtures happening today.


## Installation

1. Clone the repository.
2. Open the PremierLeagueApp.xcodeproj file in Xcode.
3. Build and run the app on a simulator or device.

## License

This app is licensed under the MIT License. See the LICENSE file for more information.

## Credits
The app was created by [Amr Saleh].
