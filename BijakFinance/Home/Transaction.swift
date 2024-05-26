//
//   TransactionView.swift
//   BijakFinance
//
//   Created by @kinderBono on 14/05/2024.
//

import SwiftUI

struct Transaction: View {
    @Environment(\.dismiss) var dismiss
    
    var name: String = ""
    var transactions: [Transactions] = []
    var amount: Double = 0
    var transactionsSorted: [Transactions] {
        transactions.sorted(by: { $0.date > $1.date })
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.creams.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    HStack {
                        Text("Total \(name)")
                            .font(.title3)
                            .bold()
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundStyle(.teals)
                            Text("\(amount, format: .currency(code: "MYR"))")
                        }
                        .frame(height: 50)
                    }
                    VStack(spacing: 0) {
                        ForEach(transactionsSorted) { transaction in
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundStyle(.whites)
                                    .frame(height: 50)
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(.blacks.opacity(0.3), lineWidth: 2)
                                    .frame(height: 50)
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("\(transaction.date, format: .dateTime)")
                                            .font(.caption2)
                                            .italic()
                                        Text(transaction.content)
                                            .font(.caption)
                                    }
                                    Spacer()
                                    Text("\(transaction.amount, format: .currency(code: "MYR"))")
                                        .font(.callout)
                                        .bold()
                                }
                                .padding()
                            }
                            .padding(.horizontal)
                        }
                    }
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
                    Text(name)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.blacks)
                }
            }
        }
    }
}

#Preview {
    Transaction(name: "Spendings", transactions: User.user.transaction["Spendings"]!)
}
