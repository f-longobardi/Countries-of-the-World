#  Countries of the world

An app to display data from https://restcountries.com/ shown in alphabetical order or by region, and a details screen for a single country with flag, official name in the device preferred language, and show a map of the country with MapKit.

Technologies used: SwiftUI, Combine, MapKit, XCTest (no third party SDKs)

Async/await was used to load data from the API, in a MVVM architecture with dependecy injection of the fetch service for testability.
Instead to download flag image I used AsyncImage with a progress view as a place holder.

XCTest and XCUITest are included.

