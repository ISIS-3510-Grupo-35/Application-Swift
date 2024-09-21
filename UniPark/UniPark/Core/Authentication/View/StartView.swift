//
//  StartView.swift
//  UniPark
//
//  Created by Tomas Angel on 21/09/24.
//

import Foundation

import SwiftUI

struct StartView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.yellow.ignoresSafeArea()
                VStack{
                    HStack{
                        Image("uniparkSign")
                            .resizable()
                            .frame(width: 240, height: 55)
                            .frame(alignment: .topLeading)
                    }
                    Text("we thrive to make your parking experience easier")
                        .padding()
                        .frame(alignment: .center)
                    Image("logo_start")
                        .resizable()
                        .frame(width: 200, height: 200)
                    
                    NavigationLink {
                        LoginView()
                        //.navigationBarBackButtonHidden(true)
                    } label: {
                        HStack {
                            Text("Start")
                                .fontWeight(.semibold)
                            Image(systemName:"arrow.right")
                        }
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    }
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                    .padding(.top, 24)
                }
            }
        }
    }
}

    
    
struct StartView_Previews: PreviewProvider {
    static var previews: some View{
        StartView()
    }
}
