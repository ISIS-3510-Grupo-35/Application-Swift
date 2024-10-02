//
//  SideMenuHeaderView.swift
//  UniPark
//
//  Created by Tomas Angel on 1/10/24.
//

import Foundation
import SwiftUI

struct SideMenuHeaderView: View {
    var body: some View {
        HStack {
            Image(systemName: "person.cicle.fill")
                .imageScale(.large)
                .foregroundStyle(.black)
                .frame(width: 48, height: 48)
                .background(.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.vertical)
            
            VStack (alignment: .leading, spacing: 6) {
                Text("Nombre de usuario")
                    .font(.subheadline)
                Text("test@gmail.com")
                    .font(.footnote)
                    .tint(.black)
            }
            
        }
    }
}

#Preview {
    SideMenuHeaderView()
}
