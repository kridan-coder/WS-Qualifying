//
//  MainView.swift
//  Qualy
//
//  Created by Daniel Krivelev on 20.04.2022.
//

import SwiftUI
import Alamofire
import Kingfisher

struct ResponseGame: Codable, Identifiable {
  let id: String
  let title: String
  let previewUrl: String
}

struct MainView: View {
  @State var games: [ResponseGame] = []
  @State var errorText = ""
  @State var showAlert = false
    var body: some View {
      ZStack {
        
        Color("Background").ignoresSafeArea()
        GeometryReader {screen in
          VStack(alignment: .leading) {
            Text("Популярно")
              .font(.custom("Manrope-Bold", size: 40))
              .foregroundColor(.white)
              .padding(.horizontal)
              .alert(errorText, isPresented: $showAlert) {
                
              }
            ScrollView(.horizontal, showsIndicators: false) {
              HStack {
                ForEach(games) { game in
                  KFImage(URL(string: game.previewUrl))
                    //.aspectRatio(2, contentMode: .fill)
                    .frame(width: 350)
                    
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    .overlay(alignment: .leading) {
                      VStack(alignment: .leading) {
                        Text(game.title)
                          .font(.custom("Manrope-Bold", size: 20))
                          .foregroundColor(.white)
                          .multilineTextAlignment(.leading)
                          .frame(width: 150)
                          .lineLimit(4)
                          .padding(.horizontal)
                        Button {
                          
                        } label: {
                          HStack {
                            Spacer()
                            Text("Играть")
                              .font(.custom("Manrope-Bold", size: 15))
                              .foregroundColor(.white)
                            Spacer()
                          }
                          .frame(width: 80, height: 30)
                          .background(RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(.white)
                            .opacity(0.4)
                          )
                          .padding(.horizontal)
                        }
                      }
                    }
                    .padding()
                }
              }
            }
            Text("Все игры")
              .font(.custom("Manrope-Bold", size: 40))
              .foregroundColor(.white)
              .padding(.horizontal)
            ScrollView(.vertical, showsIndicators: false) {
              HStack {
                ForEach(games) { game in
                  KFImage(URL(string: game.previewUrl))
                    //.aspectRatio(2, contentMode: .fill)
                    .frame(width: 350, height: 64)
                    
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    .overlay(alignment: .leading) {
                      VStack(alignment: .leading) {
                        Text(game.title)
                          .font(.custom("Manrope-Bold", size: 16))
                          .foregroundColor(.white)
                          .multilineTextAlignment(.leading)
                          .frame(width: 150)
                          .lineLimit(4)
                          .padding(8)

                      }
                    }
                    .padding()
                }
              }
            }
          }
        }
        
      }
      .onAppear {
        getGames()
      }
      
    }
  
  func getGames() {
    guard let url = URL(string: "http://62.113.103.113/api/games"),
      
      let token = UserDefaults().value(forKey: "token") as? String else { return }
    let headers: HTTPHeaders = [
      "Authorization" : "Bearer \(token)"
    ]
    AF.request(url, method: .get, headers: headers).response { response in
      if response.response?.statusCode == 401 {
        loginAF { value in
        }
        return
      }
      switch response.result {
        
      case .success(let data):
        guard let data = data,
              let decoded = try? JSONDecoder().decode([ResponseGame].self, from: data) else {
          print(response.response?.statusCode)
          errorText = "Неожиданная ошибочка.."
          showAlert.toggle()
          return
        }
        games = decoded
        print(decoded)
      case .failure(let error):
        errorText = error.localizedDescription
        showAlert.toggle()
      }
      
      
    }
  }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
      MainView(games: [ResponseGame(id: "95f01bd2-bfce-11ec-9d64-0242ac120002", title: "Найди лишнее", previewUrl: "https://gcdnb.pbrd.co/images/AGbXu4QPJiQ4.png")])
    }
}
