//
//  RequestsAF.swift
//  Qualy
//
//  Created by Daniel Krivelev on 20.04.2022.
//

import Foundation
import Alamofire

func loginAF(completion: @escaping (Bool) -> Void) {
  guard let nickname = UserDefaults().value(forKey: "nickname") as? String else { return }
  guard let url = URL(string: "http://62.113.103.113/api/auth/login") else { return }
  AF.request(url, method: .post, parameters: nickname, encoder: JSONParameterEncoder.default).validate(statusCode: 200...200).response { result in
    switch result.result {
    case .success(let data):
      guard let data = data,
        let decoded = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
        return }
      UserDefaults().set(decoded.accessToken.token, forKey: "token")
      print(decoded)
      completion(true)
    case .failure(let error):
      completion(false)
    }
  }
  
}
