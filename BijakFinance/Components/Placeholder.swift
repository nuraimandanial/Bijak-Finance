//
//   Placeholder.swift
//   BijakFinance
//
//   Created by @kinderBono on 09/05/2024.
//   

import SwiftUI

struct Placeholder: View {
    var width: CGFloat = 180
    var height: CGFloat = 120
    var shape: Shape = .roundedRectangle
    
    var body: some View {
        ZStack {
            shape.shapeView()
                .foregroundStyle(.gray.opacity(0.25))
                .frame(width: width, height: height)
            VStack {
                if width >= 80 {
                    Text("Image")
                        .font(.caption2)
                }
            }
            .padding()
        }
        .frame(width: width, height: height)
        .environment(\.colorScheme, .light)
    }
    
    enum Shape {
        case circle, rectangle, roundedRectangle
        
        func shapeView() -> some View {
            switch self {
            case .circle:
                return AnyView(Circle())
            case .rectangle:
                return AnyView(Rectangle())
            case .roundedRectangle:
                return AnyView(RoundedRectangle(cornerRadius: 25))
            }
        }
    }
}
