//
//   ToolbarTop.swift
//   BijakFinance
//
//   Created by @kinderBono on 09/05/2024.
//

import SwiftUI

struct Toolbar: ToolbarContent {
    var text: String = ""
    var image: String = ""
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Text(text)
                .font(.title2)
                .bold()
                .foregroundStyle(.blacks)
        }
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            if text != "Account" {
                NavigationLink(destination: {
                    Notification()
                }, label: {
                    Image(systemName: "bell")
                        .foregroundStyle(.blacks)
                })
                AsyncImage(url: URL(string: image)) { result in
                    switch result {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    case .failure(_):
                        if !image.isEmpty {
                            Image(image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } else {
                            Placeholder(width: 50, height: 50, shape: .circle)
                        }
                    @unknown default:
                        fatalError()
                    }
                }
            }
        }
    }
}
