//
//   FolderContent.swift
//   BijakFinance
//
//   Created by @kinderBono on 14/05/2024.
//   

import SwiftUI

struct FolderContent: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var folderItem: FolderItem
    @State var selectedReceipt: Receipt = .init()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.creams.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(.whites)
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.blacks.opacity(0.3), lineWidth: 2)
                        Text("\(folderItem.amount, format: .currency(code: "MYR"))")
                    }
                    .frame(height: 50)
                    .padding(.horizontal, 40)
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(), GridItem()], spacing: 10) {
                            ForEach(folderItem.receipts) { receipt in
                                AsyncImage(url: URL(string: receipt.url)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .contextMenu {
                                            NavigationLink(destination: {
                                                EmptyView()
                                            }, label: {
                                                Label("See Description", systemImage: "info.circle")
                                            })
                                            Button(role: .destructive, action: {
                                                selectedReceipt = receipt
                                                deleteReceipt()
                                            }, label: {
                                                Label("Delete Receipt", systemImage: "trash")
                                            })
                                        } preview: {
                                            withAnimation {
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                            }
                                        }
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(height: 250)
                            }
                        }
                    }
                }
                .padding([.horizontal, .top])
            }
            .foregroundStyle(.blacks)
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
                    Text(folderItem.name)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.blacks)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: {
                        UploadReceipt()
                            .environmentObject(appModel)
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.yellows)
                    })
                }
            }
        }
    }
    
    func deleteReceipt() {
        appModel.dataManager.deleteReceipt(fromCategory: folderItem.name, withUrl: selectedReceipt.url) { success, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    FolderContent(folderItem: .constant(FolderItem(name: "Test", receipts: [Receipt(itemImage: "0", url: "https://firebasestorage.googleapis.com/v0/b/bijakfinance-c63ae.appspot.com/o/SZgNpogWcuNDxMdZQZdaHyZ1jju2%2Freceipts%2FLifestyle%2F0.jpg?alt=media&token=d67b1da2-bf29-4c53-8001-df8dca4a80c6", amount: 20), Receipt(itemImage: "0", url: "https://firebasestorage.googleapis.com/v0/b/bijakfinance-c63ae.appspot.com/o/SZgNpogWcuNDxMdZQZdaHyZ1jju2%2Freceipts%2FLifestyle%2F0.jpg?alt=media&token=d67b1da2-bf29-4c53-8001-df8dca4a80c6", amount: 20)])))
        .environmentObject(AppModel())
}
