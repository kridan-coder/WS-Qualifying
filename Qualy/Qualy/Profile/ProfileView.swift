//
//  ProfileView.swift
//  Qualy
//
//  Created by Daniel Krivelev on 20.04.2022.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
      Spacer()
      HStack {
        Spacer()
        Image("Codzima").resizable().frame(width: 128, height: 128)
        Spacer()
      }
      .padding()
      HStack {
        Spacer()
        Text("Codezima")
          .font(.custom("Manrope-Bold", size: 40))
          .foregroundColor(.white)
          .padding(.bottom, 40)
        Spacer()
      }
      
      RoundedRectangle(cornerRadius: 8)
        .frame(height: 65)
        .foregroundColor(Color("DarkViolet"))
        .overlay(alignment:.leading) {
          HStack {
            Text("1")
              .font(.custom("Manrope-Bold", size: 18))
              .foregroundColor(.white)
              .padding(.trailing, 6)
            
            Text("Codezima")
              .font(.custom("Manrope-Regular", size: 18))
              .foregroundColor(.white)
            Spacer()
            
            Text("5,7k")
              .font(.custom("Manrope-Bold", size: 18))
              .foregroundColor(.white)
          }
          .padding(20)
        }
        .padding()
        
      
      Text("Последняя игра")
        .font(.custom("Manrope-Bold", size: 25))
        .foregroundColor(.white)
        .padding(.horizontal)
      
      Image("Hardcode")
        .scaledToFill()
        .frame(width: nil)
        .padding(.horizontal)
        
        .overlay(alignment: .leading) {
          VStack(alignment: .leading, spacing: 15) {
            Text("Super Memo")
              .font(.custom("Manrope-Bold", size: 35))
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
            .padding(.horizontal)
          }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
