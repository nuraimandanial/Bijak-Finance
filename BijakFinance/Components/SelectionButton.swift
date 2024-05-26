//
//   SelectionButton.swift
//   BijakFinance
//
//   Created by @kinderBono on 09/05/2024.
//   

import SwiftUI

struct SelectionButton: View {
    @Binding var selection: Bool
    var text: String = ""
    var color: Color = .gray
    
    var body: some View {
        Button(action: {
            selection.toggle()
        }, label: {
            ZStack {
                ButtonLabel(text: text, color: selection ? .red.opacity(0.5) : color)
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.blacks.opacity(0.3), lineWidth: 2)
            }
        })
    }
}
