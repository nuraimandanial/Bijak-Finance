//
//   Home.swift
//   BijakFinance
//
//   Created by @kinderBono on 07/05/2024.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var appModel: AppModel
    
    @State var data: [String: Double] = [:]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.creams.ignoresSafeArea()
                
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(data.keys.sorted(), id: \.self) { key in
                                NavigationLink(destination: {
                                    Transaction(
                                        name: key,
                                        transactions: appModel.dataManager.currentUser.transaction[key] ?? [],
                                        amount: data[key] ?? 0
                                    )
                                }, label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundStyle(.turqois)
                                        VStack(alignment: .leading, spacing: 10) {
                                            HStack {
                                                Text("\(key)")
                                                    .font(.title3)
                                                    .bold()
                                                Spacer()
                                            }
                                            Text("\(data[key]!, format: .currency(code: "MYR"))")
                                                .font(.title2)
                                        }
                                        .padding()
                                        .foregroundStyle(.blacks)
                                    }
                                    .frame(width: 180, height: 140)
                                })
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    VStack(spacing: 40) {
                        VStack(spacing: 20) {
                            HStack {
                                Text("Spending Limit")
                                    .font(.title2)
                                    .bold()
                                Spacer()
                            }
                            ProgressBar(
                                totalBudget: appModel.dataManager.currentUser.totalBudget,
                                currentSpending: appModel.dataManager.currentUser.currentSpending
                            )
                        }
                        
                        Banner()
                    }
                    .padding()
                }
                .padding(.top)
            }
        }
        .foregroundStyle(.blacks)
        .task {
            data = [
                "Savings": appModel.dataManager.currentUser.savings,
                "Spendings": appModel.dataManager.currentUser.spendings.totalSpending()
            ]
        }
    }
}

#Preview {
    Home()
        .environmentObject(AppModel())
}

struct ProgressBar: View {
    var totalBudget: Double
    var currentSpending: Double
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let ratio = currentSpending / (totalBudget < 1 ? 1 : totalBudget)
            let progress = min(width * CGFloat(ratio), width)
            
            VStack {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundStyle(.whites)
                        .frame(width: width)
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundStyle(ratio > 1 ? .red : .yellows)
                        .frame(width: totalBudget < 1 ? 0 : abs(progress))
                }
                .frame(height: 30)
                HStack {
                    Spacer()
                    Text("(\(currentSpending, format: .currency(code: "MYR")) / \(totalBudget, format: .currency(code: "MYR")))")
                        .font(.caption)
                        .italic()
                }
            }
        }
        .frame(height: 40)
    }
}

struct Banner: View {
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    @State var currentIndex = 0
    var items = BannerItem.items
    
    var body: some View {
        GeometryReader { geo in
            TabView(selection: $currentIndex) {
                ForEach(Array(items.enumerated()), id: \.element) { index, item in
                    ZStack {
                        Placeholder(width: geo.size.width - 10, height: 200, shape: .roundedRectangle)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .frame(height: 200)
            .onReceive(timer) { _ in
                withAnimation {
                    currentIndex = (currentIndex + 1) % items.count
                }
            }
        }
    }
}

struct BannerItem: Identifiable {
    var id = UUID()
    
    var name: String = ""
    var image: String = ""
}

extension BannerItem {
    static let items = [
        BannerItem(name: "Ads One", image: "ads"),
        BannerItem(name: "Ads Two", image: "ads"),
        BannerItem(name: "Ads Three", image: "ads")
    ]
}

extension BannerItem: Codable, Hashable {}
