//
//  RatingView.swift
//  Qualy
//
//  Created by Daniel Krivelev on 21.04.2022.
//

import Alamofire
import SwiftUI

struct UserResults: Codable, Identifiable {
  let id: String
  let points: Int
  let userNickname: String
}

struct RatingView: View {
  @State var showAlert = false
  @State var errorText = ""
  @State var results: [UserResults] = []
    var body: some View {
      Text("Рейтинг")
        .font(.custom("Manrope-Bold", size: 40))
        .foregroundColor(.white)
        .padding()
        .alert(errorText, isPresented: $showAlert) {
          
        }
      
      ScrollView(.vertical, showsIndicators: false ) {
        ForEach(Array(results.enumerated()), id: \.element.id) { index, result in
          RoundedRectangle(cornerRadius: 8)
            .frame(height: 65)
            .foregroundColor(Color("DarkViolet"))
            .overlay(alignment:.leading) {
              HStack {
                Text("\(index + 1)")
                  .font(.custom("Manrope-Bold", size: 18))
                  .foregroundColor(.white)
                  .padding(.trailing, 6)
                
                Text(result.userNickname)
                  .font(.custom("Manrope-Regular", size: 18))
                  .foregroundColor(.white)
                Spacer()
                
                Text(String(result.points > 1000 ? Double(Double(result.points) / 1000) : Double(result.points).rounded()) + (result.points > 1000 ? "k" : ""))
                  .font(.custom("Manrope-Bold", size: 18))
                  .foregroundColor(.white)
              }
              .padding(20)
            }
            .padding(.horizontal)
            .padding(.vertical, 3)
        }
      }
      .onAppear {
        getResults()
      }
    }
  
  func getResults() {
    guard let game = UserDefaults().value(forKey: "game") as? String else { return }
    guard let url = URL(string: "http://62.113.103.113/api/games/\(game)/results"),
      
      let token = UserDefaults().value(forKey: "token") as? String else { return }
    let headers: HTTPHeaders = [
      "Authorization" : "Bearer \(token)"
    ]
    AF.request(url, method: .get, headers: headers).response { response in
      if response.response?.statusCode == 401 {
        loginAF { value in
          if value {
            getResults()
          }
          
        }
        
      }
      switch response.result {
        
      case .success(let data):
        guard let data = data,
              let decoded = try? JSONDecoder().decode([UserResults].self, from: data) else {
          print(response.response?.statusCode)
          errorText = "Неожиданная ошибочка.."
          showAlert.toggle()
          return
        }
        results = decoded.sorted { $0.points < $1.points }
        print(decoded)
      case .failure(let error):
        errorText = error.localizedDescription
        showAlert.toggle()
      }
      
      
    }
  }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView()
    }
}
