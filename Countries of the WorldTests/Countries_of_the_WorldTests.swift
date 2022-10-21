//
//  Countries_of_the_WorldTests.swift
//  Countries of the WorldTests
//
//  Created by Sabato Francesco Longobardi on 17/10/22.
//

import XCTest
@testable import Countries_of_the_World

//Mocked fetch service to receive a single country (Italy)
class mockFetchService: FetchService{
    func fetchCountries() async throws -> Set<Countries_of_the_World.Country> {
        var countries = Set<Country>()
        countries.insert(Country())
        return countries
    }
}

//Mocked fetch service to receive an URLError
class mockFetchServiceFail: FetchService{
    func fetchCountries() async throws -> Set<Countries_of_the_World.Country> {
        throw URLError(.badServerResponse)
    }
}

final class Countries_of_the_WorldTests: XCTestCase {
    
    var vmSUT : CountryViewModelImpl!

    @MainActor override func setUpWithError() throws {
        vmSUT = CountryViewModelImpl(service: mockFetchService())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchingData() async throws {
        await vmSUT.getCountries()
        await vmSUT.$state.sink(){ completion in
            switch completion{
            case .success(let data):
                XCTAssertFalse(data.isEmpty)
                XCTAssertEqual(Country(),data.first!.value.first)
            default:
                XCTFail("Expected country dictionary")
            }
            print(completion)
        }.cancel()
    }
    
    func testChangeSorting() async {
        await vmSUT.getCountries()
        var initialKey : String = ""
        var finalKey : String = ""
        let sort = await vmSUT.sortedBy
        
        var state = await vmSUT.state
        switch state{
        case .success(let data):
            initialKey = data.first!.key
        default:
            XCTFail("Expected country dictionary")
        }
        
        await vmSUT.toggleSortOrder()
        let afterSort = await vmSUT.sortedBy
        
        state = await vmSUT.state
        switch state{
        case .success(let data):
            finalKey = data.first!.key
        default:
            XCTFail("Expected country dictionary")
        }
        
        XCTAssertNotEqual(sort, afterSort)
        XCTAssertNotEqual(initialKey, finalKey)
    }
    
    @MainActor func testFetchingFail() async{
        vmSUT = CountryViewModelImpl(service: mockFetchServiceFail())
        await vmSUT.getCountries()
        vmSUT.$state.sink(){ completion in
            switch completion{
            case .error(let error):
                XCTAssertNotNil(error)
            default:
                XCTFail("Expected Error")
            }
            print(completion)
        }.cancel()
    }

}
