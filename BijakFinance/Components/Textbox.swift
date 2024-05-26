//
//   Textbox.swift
//   BijakFinance
//
//   Created by @kinderBono on 08/05/2024.
//   

import SwiftUI

struct Textbox: View {
    var hint: String = ""
    @Binding var text: String
    var fieldType: Field = .text
    
    var body: some View {
        if fieldType == .text {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.whites)
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.blacks.opacity(0.3), lineWidth: 2)
                TextField(hint, text: $text)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(10)
            }
            .frame(height: 50)
            .environment(\.colorScheme, .light)
        } else if fieldType == .password {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.whites)
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.blacks.opacity(0.3), lineWidth: 2)
                SecureField(hint, text: $text)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(10)
            }
            .frame(height: 50)
            .environment(\.colorScheme, .light)
        }
    }
    
    enum Field {
        case text, password
    }
}
