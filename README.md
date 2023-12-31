# StudyPlanet iOS

> The Study Planet App is designed to help users stay focused and productive by incorporating gamification elements into their learning experience. The app encourages users to concentrate on their studies or work by allowing them to discover and explore virtual planets on their iOS devices.

## Dependencies

- [iOS v16.2](https://support.apple.com/en-us/HT213407)
- [CoreData](https://developer.apple.com/documentation/coredata/)
- [SWinject v2.8.4](https://github.com/Swinject/Swinject)
- [JWTDecode.swift v3.1.0](https://github.com/auth0/JWTDecode.swift)
- [SwiftyBeaver v2.0.0](https://github.com/SwiftyBeaver/SwiftyBeaver)

## Demo

https://github.com/Qwict/StudyPlanetiOS/assets/100297369/bd1141dd-794e-4341-9a4e-4efcd1dabf71

> This Demo of the StudyPlanetiOS application shows how the application can be run on an iPhone simulator within MacOS. It also shows how iOS app interacts with the backend running in development mode on localhost. This recording is also available at [cloud.qwict.com](https://cloud.qwict.com/s/bqif9BWcHZ2EZCS).

## Backend
The backend is hosted at [sp.qwict.com/api](https://sp.qwict.com/api/v1/health/version). And it's source code can be found [github.com/Qwict/StudyPlanetNodeAPI](https://github.com/Qwict/StudyPlanetNodeAPI).

## Android App
An Android version of this application is also available at [github.com/Qwict/StudyPlanetAndroid](https://github.com/Qwict/StudyPlanetiOS) and can be downloaded from the [Github Releases](https://github.com/Qwict/StudyPlanetAndroid/releases/latest).

## Running this application
You could download the [StudyPlanet.app](https://github.com/Qwict/StudyPlanetiOS/releases/latest) and run it on a iPhone simulator in MacOS like done in the demo.

Or build and run it with your IDE:
1. Clone this repository
2. Open the `StudyPlanet.xcodeproj` file in Xcode or in AppCode
3. Run the application on a simulator or device

> API configuration should not be required as long as the `BASE_URL` in `StudyPlanet/Common/Constants` is set to `https://sp.qwict.com/api/v1/`. And if this API is still online ofcourse.

> You could opt to run the backend (NodeJS) locally, and clone it from [github.com/Qwict/StudyPlanetNodeAPI](https://github.com/Qwict/StudyPlanetNodeAPI)

## Feedback and bug reporting
Bugs and issues can be reported on the [GitHub Issues](https://github.com/Qwict/StudyPlanetiOS/issues). Feedback is greatly apreciated and can be placed in the [GitHub Discussions](https://github.com/Qwict/StudyPlanetiOS/discussions).
