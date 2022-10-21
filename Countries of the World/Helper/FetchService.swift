//
//  FetchService.swift
//  Countries of the World
//
//  Created by Sabato Francesco Longobardi on 19/10/22.
//

import Foundation

protocol FetchService {
    func fetchCountries() async throws -> Set<Country>
}

class FetchCountries: FetchService{
    
    func fetchCountries() async throws -> Set<Country>{
        var countriesData = Set<Country>()
        guard let url = URL(string: "https://restcountries.com/v3.1/all") else {return countriesData}
        do{
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let resp = response as? HTTPURLResponse else{
                throw URLError(.badServerResponse)
            }
            if resp.statusCode < 200 || resp.statusCode > 299 {
                throw URLError(URLError.Code(rawValue: resp.statusCode))
            }
            
            // Used serialization insted of JSONDecoder().decode([Country].self, from: data) because I didn't need many of the nested fields that I had to map if I wanted to use decode
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:AnyObject]]{
                for countryData in json{
                    let country = Country.init(data: countryData)
                    countriesData.insert( country)
                }
            }
            return countriesData
        }
    }
    
    
}
