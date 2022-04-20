//
//  ContentView.swift
//  Qualy
//
//  Created by Daniel Krivelev on 20.04.2022.
//

import SwiftUI
import Kingfisher
import Alamofire

struct LoginForm: Codable {
  let nickname: String
}

struct LoginResponse: Codable {
  let accessToken: Token
  let refreshToken: Token
}

struct Token: Codable {
  let token: String
  let expiresIn: Int
}


struct ContentView: View {
  @State var showAlert = false
  @State var showErrorAlert = false
  @State var text = ""
  @State var errorText = ""
    var body: some View {
      ZStack {
        Color("Background").ignoresSafeArea()
        VStack {
          Spacer()
          Image("InitImage")
          Text("MindGames")
            .font(.custom("Manrope-Bold", size: 30))
            .foregroundColor(Color("Violet"))
            .padding(.bottom)
          
          VStack(alignment: .leading, spacing: 0) {
            Text("Никнейм")
              .font(.custom("Manrope-Light", size: 15))
              .foregroundColor(Color("Violet"))
              .padding(.horizontal)
            TextField("Введите никнейм", text: $text)
              .padding(10)
              .font(.custom("Manrope-Light", size: 15))
              .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.white))
              .padding(.horizontal)
              .padding(.top, 3)
              .padding(.bottom, 10)
            
            Button {
              login()
            } label: {
              HStack {
                Spacer()
                Text("Войти")
                  .font(.custom("Manrope-Bold", size: 15))
                  .foregroundColor(Color.black)
                  
                Spacer()
                  
              }
              .padding(12)
              .background(RoundedRectangle(cornerRadius: 28).foregroundColor(Color("Cyan")))
              .padding(.horizontal)
            }
          }
          .alert(errorText, isPresented: $showAlert) {
            
          }
          
          
          Spacer()
          
        }
      }
      
            
    }
  
  func login() {
    if text.isEmpty {
      showAlert = true
      errorText = "Введите данные!"
      return
    }
    let nickname = LoginForm(nickname: text)
    guard let url = URL(string: "http://62.113.103.113/api/auth/login") else { return }
    AF.request(url, method: .post, parameters: nickname, encoder: JSONParameterEncoder.default).validate(statusCode: 200...200).response { result in
      switch result.result {
      case .success(let data):
        guard let data = data,
          let decoded = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
          errorText = "Неожиданная ошибка..."
          showAlert.toggle()
          return }
        UserDefaults().set(decoded.accessToken.token, forKey: "token")
        print(decoded)
        
      case .failure(let error):
        errorText = error.localizedDescription
        showAlert.toggle()
      }
    }
    
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
