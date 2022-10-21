//
//  CountryDetailsView.swift
//  Countries of the World
//
//  Created by Sabato Francesco Longobardi on 17/10/22.
//

import SwiftUI
import MapKit

struct CountryDetailsView: View {
    let country : Country?
    var body: some View {
        VStack(alignment: .leading){
            HStack(){
                AsyncImage(url: URL(string: country?.flagUrl ?? "")) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 67).padding(1).border(Color(.label))
                VStack(alignment: .leading){
                    Text(country?.translations[Locale.current.getIsoCode()] ?? "")
                        .multilineTextAlignment(.leading)
                    Text("Capital: \(country?.capital ?? "")")
                        .multilineTextAlignment(.leading)
                    Text("Languages: \(country?.languages.formatted() ?? "")")
                        .multilineTextAlignment(.leading)
                }
            }.padding(10)
            
            Map(coordinateRegion: .constant(.init(center: CLLocationCoordinate2D(latitude: ((country?.latlng.first) ?? 0)!, longitude: ((country?.latlng.last) ?? 0)!), span: .init(latitudeDelta: 5, longitudeDelta: 5))))
        }.navigationTitle(country?.commonName ?? "").navigationBarTitleDisplayMode(.inline)
    }
}

struct CountryDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetailsView(country: Country())
    }
}
