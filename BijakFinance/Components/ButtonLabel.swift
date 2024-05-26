//
//   ButtonLabel.swift
//   BijakFinance
//
//   Created by @kinderBono on 08/05/2024.
//   

import SwiftUI

struct ButtonLabel: View {
    var text: String = "text"
    var image: String = ""
    var color: Color = .teals
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(color)
            if image != "" {
                HStack(spacing: 10) {
                    Image(systemName: image)
                        .foregroundStyle(color != .red ? .blacks : .whites)
                    Text(text)
                        .font(.body)
                        .foregroundStyle(color != .red ? .blacks : .whites)
                }
                .padding()
            } else {
                Text(text)
                    .font(.body)
                    .foregroundStyle(color != .red ? .blacks : .whites)
                    .padding()
            }
        }
        .frame(height: 50)
        .environment(\.colorScheme, .light)
    }
}
