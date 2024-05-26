//
//   ReceiptDetail.swift
//   BijakFinance
//
//   Created by @kinderBono on 21/05/2024.
//   

import SwiftUI

struct ReceiptDetail: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.creams.ignoresSafeArea()
                
                VStack {
                    
                }
                .padding([.horizontal, .top])
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.yellows)
                    })
                    Spacer()
                    Text("")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.blacks)
                }
            }
        }
    }
}

#Preview {
    ReceiptDetail()
        .environmentObject(AppModel())
}
