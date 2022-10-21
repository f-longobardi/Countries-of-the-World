//
//  ContentView.swift
//  Countries of the World
//
//  Created by Sabato Francesco Longobardi on 17/10/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CountryViewModelImpl()
    
    var body: some View {
        NavigationView{
            switch viewModel.state{
            case .initial:
                ProgressView()
                    .navigationTitle("Countries")
            case .success(let countries):
                List {
                    ForEach(countries.keys.sorted(), id:\.self) { key in
                        if let countries = countries[key]
                        {
                            Section(header: Text("\(key)")) {
                                ForEach(countries){ country in
                                    NavigationLink( destination: CountryDetailsView(country: country)){
                                        HStack{
                                            Text(country.commonName ?? "").font(.subheadline)
                                            Text(country.emojiFlag ?? "⚐")
                                        }.padding()
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Countries")
                .navigationBarItems(trailing:
                                        Button(action: {
                    self.viewModel.toggleSortOrder()
                }) {
                    Image(systemName: "arrow.up.arrow.down.square")
                })
                .refreshable {
                    await viewModel.getCountries()
                }
            case .error(let error):
                ProgressView()
                    .navigationTitle("Countries")
                    .alert(isPresented: .constant(true)) {
                        Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .cancel(Text("Cancel")))
                    }
            }
            
        }
        .task {
            await viewModel.getCountries()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
