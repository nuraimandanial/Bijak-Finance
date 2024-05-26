//
//   UploadReceipt.swift
//   BijakFinance
//
//   Created by @kinderBono on 15/05/2024.
//   

import SwiftUI

struct UploadReceipt: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    @State var showImagePicker: Bool = false
    @State var selectedImage: UIImage?
    @State var amount: String = ""
    
    @State var folders: [FolderItem] = []
    @State var selectedFolderIndex: Int = 0
    var folder: FolderItem {
        folders[selectedFolderIndex]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.creams.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    } else {
                        VStack(spacing: 20) {
                            Placeholder(height: 130, shape: .rectangle)
                            Button(action: {
                                showImagePicker = true
                            }, label: {
                                ButtonLabel(text: "Upload", image: "square.and.arrow.up")
                                    .padding(.horizontal, 40)
                            })
                            .sheet(isPresented: $showImagePicker) {
                                ImagePicker(image: $selectedImage)
                            }
                        }
                    }
                    HStack {
                        Text("Select Category")
                        Spacer()
                        Picker("Select Category", selection: $selectedFolderIndex) {
                            ForEach(folders.indices, id: \.self) { index in
                                Text(folders[index].name).tag(index)
                            }
                        }
                        .environment(\.colorScheme, .light)
                    }
                    Textbox(hint: "Enter Amount", text: $amount)
                    
                    Button(action: {
                        saveReceipt()
                    }, label: {
                        ButtonLabel(text: "Save Image", color: .yellows)
                            .padding(.horizontal, 40)
                    })
                    Spacer()
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
                    Text("Upload Receipts")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.blacks)
                }
            }
            .task {
                folders = appModel.dataManager.currentUser.folders
            }
        }
    }
    
    func storeImage(image: UIImage?) -> String {
        return "\(folder.receipts.count)"
    }
    
    func saveReceipt() {
        guard let image = selectedImage, let amount = Double(amount) else {
            return
        }
        
        appModel.dataManager.addReceipt(category: folder.name, itemImage: storeImage(image: selectedImage), image: image, amount: amount) { result in
            switch result {
            case .success(let url):
                print("Receipt Uploaded Successfully: \(url)")
                dismiss()
            case .failure(let error):
                print("Error Uploading Receipt: \(error)")
            }
        }
    }
}

#Preview {
    UploadReceipt()
        .environmentObject(AppModel())
}
