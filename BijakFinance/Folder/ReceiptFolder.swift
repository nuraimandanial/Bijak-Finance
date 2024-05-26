//
//   ReceiptFolder.swift
//   BijakFinance
//
//   Created by @kinderBono on 08/05/2024.
//   

import SwiftUI
import Vision
import Photos

struct ReceiptFolder: View {
    @EnvironmentObject var appModel: AppModel
    
    @State var folders: [FolderItem] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.creams.ignoresSafeArea()
                
                VStack {
                    NavigationLink(destination: {
                        UploadReceipt()
                            .environmentObject(appModel)
                    }, label: {
                        ButtonLabel(text: "Upload Receipt", image: "square.and.arrow.up", color: .yellows)
                            .padding(.horizontal)
                    })
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            LazyVGrid(columns: [GridItem(), GridItem()], spacing: 10) {
                                ForEach($folders, id: \.self) { $folder in
                                    NavigationLink(destination: {
                                        FolderContent(folderItem: $folder)
                                            .environmentObject(appModel)
                                    }, label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 25.0)
                                                .foregroundStyle(.turqois)
                                            VStack {
                                                Image(systemName: "folder.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 60)
                                                    .foregroundStyle(.whites)
                                                    .padding(.top, 40)
                                                Spacer()
                                            }
                                            VStack {
                                                Spacer()
                                                Text(folder.name)
                                                    .foregroundStyle(.blacks)
                                                    .padding()
                                                    .lineLimit(2)
                                            }
                                        }
                                        .frame(height: 155)
                                    })
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                }
                .padding(.top)
            }
            .foregroundStyle(.blacks)
            .task {
                folders = appModel.dataManager.currentUser.folders
            }
        }
    }
}

#Preview {
    ReceiptFolder()
        .environmentObject(AppModel())
}
