//
//  CountryViewModel.swift
//  Countries of the World
//
//  Created by Sabato Francesco Longobardi on 18/10/22.
//

import Foundation

protocol CountryViewModel: ObservableObject {
    func getCountries() async
    func toggleSortOrder() async
}

@MainActor class CountryViewModelImpl : CountryViewModel {
    private var countriesData : [Country] = []

    @Published private(set) var state: State = .initial
    
    enum OrderType{
        case name
        case region
    }
    
    enum State{
        case initial
        case error(Error)
        case success(Dictionary<String , [Country]>)
    }
    
    private(set) var sortedBy: OrderType = .name {
        didSet{
            if self.countriesData.isEmpty{return}
            switch sortedBy{
            case .name:
                self.dictionaryByName(countries: self.countriesData)
            case .region:
                self.dictionaryByRegion(countries: self.countriesData)
            }
        }
    }
    
    private let fetchService : FetchService
    
    // for dependency injection
    init(service: FetchService? = nil){
        if let service{
            self.fetchService = service
        }else{
            self.fetchService = FetchCountries()
        }
    }
    
    private func dictionaryByName(countries: [Country]) {
            let sectionDictionary: Dictionary<String, [Country]> = {
                return Dictionary(grouping: countries, by: {
                    let name = $0.commonName
                    if let normalizedName = name?.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current).first{
                        let firstLetter = String(normalizedName).uppercased()
                        return firstLetter
                    }else{
                        return ""
                    }
                })
            }()
        self.state = .success(sectionDictionary)
        }
    
    private func dictionaryByRegion(countries: [Country]) {
        let sectionDictionary: Dictionary<String, [Country]> = {
            return Dictionary(grouping: countries, by: {
                let name = $0.region
                if let normalizedName = name?.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current){
                    return normalizedName.uppercased()
                }else{
                    return ""
                }
            })
        }()
        self.state = .success(sectionDictionary)
    }
    
    func getCountries() async {
        do{
            let countries = try await fetchService.fetchCountries()
                .sorted(by: {$0.commonName?.lowercased() ?? "" <= $1.commonName?.lowercased() ?? ""})
            self.countriesData = countries
            switch self.sortedBy {
            case .name:
                self.dictionaryByName(countries: countries)
            case .region:
                self.dictionaryByRegion(countries: countries)
            }
        }catch let error{
            print("Error: \(error.localizedDescription)")
            // Errors are captured here and sent with the state
            self.state = .error(error)
        }
    }
    
    func toggleSortOrder() {
        switch sortedBy{
            
        case .name:
            self.sortedBy = .region
        case .region:
            self.sortedBy = .name
        }
    }
}
