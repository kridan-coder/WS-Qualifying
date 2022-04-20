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
  @State var currentTab = 0
  
  @State var isPlaying = false
    var body: some View {
      if isPlaying {
        GameView()
      } else {
        ZStack {
          
          Color("Background").ignoresSafeArea()
          GeometryReader {screen in
            VStack(alignment: .leading) {
            if currentTab == 0 {
              
                Text("Популярно")
                  .font(.custom("Manrope-Bold", size: 40))
                  .foregroundColor(.white)
                  .padding()
                  .alert(errorText, isPresented: $showAlert) {
                    
                  }
                  .onAppear {
                    getGames()
                  }
                ScrollView(.horizontal, showsIndicators: false) {
                  HStack(spacing: -10) {
                    ForEach(games) { game in
                      KFImage(URL(string: game.previewUrl))
                        //.aspectRatio(2, contentMode: .fill)
                        .frame(width: 340)
                        
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
                              isPlaying = true
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
                  VStack(spacing: 15) {
                    
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
                        .padding(.horizontal)
                    }
                  }
                }
                
                
               
            } else if currentTab == 1 {
              RatingView()
            } else if currentTab == 2 {
              ProfileView()
            }
            
            Spacer()
            VStack(spacing: 0) {
              Rectangle()
                .foregroundColor(Color("Selection"))
                .frame(width: nil, height: 1)
                .padding(.bottom, 7)
              HStack {
                Spacer()
                VStack(spacing: 3) {
                  
                  Button {
                    currentTab = 0
                  } label: {
                    Image("Main")
                      .renderingMode(.template)
                      .foregroundColor(currentTab == 0 ? Color("Cyan") : Color("Selection"))
                    
                }
                  Text("Главная")
                    .font(.custom("Manrope-Regular", size: 12))
                    .foregroundColor(currentTab == 0 ? Color("Cyan") : Color("Selection"))
                  
                }
                Spacer()
                VStack(spacing: 3) {
                  
                  Button {
                    currentTab = 1
                  } label: {
                    Image("Rating")
                      .renderingMode(.template)
                      .foregroundColor(currentTab == 1 ? Color("Cyan") : Color("Selection"))
                    
                }
                  Text("Рейтинг")
                    .font(.custom("Manrope-Regular", size: 12))
                    .foregroundColor(currentTab == 1 ? Color("Cyan") : Color("Selection"))
                  
                }
                
                Spacer()
                
                VStack(spacing: 3) {
                  
                  Button {
                    currentTab = 2
                  } label: {
                    Image("Profile")
                      .renderingMode(.template)
                      .foregroundColor(currentTab == 2 ? Color("Cyan") : Color("Selection"))
                    
                }
                  Text("Профиль")
                    .font(.custom("Manrope-Regular", size: 12))
                    .foregroundColor(currentTab == 2 ? Color("Cyan") : Color("Selection"))
                  
                }
                
                Spacer()
              }
            }
              
            
          }
          
        }
        
      }
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
          if value {
            getGames()
          }
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
        if let first = games.first {
          UserDefaults().set(first.id, forKey: "game")
        }
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
      MainView(games: [ResponseGame(id: "95f01bd2-bfce-11ec-9d64-0242ac120002", title: "Найди лишнее", previewUrl: "https://gcdnb.pbrd.co/images/AGbXu4QPJiQ4.png"), ResponseGame(id: "95f01bd2-bfce-11ec-9d64-0242ac120002", title: "Найди лишнее", previewUrl: "https://gcdnb.pbrd.co/images/AGbXu4QPJiQ4.png")])
    }
}
