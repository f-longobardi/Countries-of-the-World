//
//  Country.swift
//  Countries of the World
//
//  Created by Sabato Francesco Longobardi on 17/10/22.
//

import Foundation


struct Country:Identifiable, Hashable{
    let id: String?
    let commonName: String?
    let latlng: [Double?]
    let capital: String?
    let emojiFlag: String?
    let languages: [String]
    let flagUrl: String?
    let region: String?
    let area: Double?
    let translations: [String:String]
    
    
    init(data: [String:AnyObject]){
        let nameDict = data["name"]
        let commonName = nameDict?["common"] as? String
        let officialName = nameDict?["official"] as? String
        let latlng = data["latlng"] as? [Double]
        let capital = data["capital"] as? [String]
        let emojiFlag = data["flag"] as? String
        let flagsDict = data["flags"] as? [String:String]
        let languages = data["languages"]?.allValues as? [String]
        let region = data["region"] as? String
        let area = data["area"] as? Double
        var translations = (data["translations"] as? [String:[String:String]])?.compactMapValues( {
            value in
            return value["official"]
        })
        translations?["eng"] = officialName
        
        self.commonName = commonName
        self.latlng = latlng ?? []
        self.capital = capital?.first ?? ""
        self.emojiFlag = emojiFlag
        self.flagUrl = flagsDict?["png"]
        self.languages = languages ?? []
        self.region = region
        self.translations = translations ?? [:]
        self.area = area
        self.id = commonName
    }
    
    // Used for preview and testing
    init(){
        self.commonName = "Italia"
        self.latlng = [41.0,12.0]
        self.capital = "Roma"
        self.emojiFlag = "🇮🇹"
        self.flagUrl = "https://flagcdn.com/w320/it.png"
        self.languages = ["italian"]
        self.region = "Europe"
        self.translations = ["usa":"Italian Republic","ita":"Repubblica italiana"]
        self.area = 40000
        self.id = "IT"
    }
}
