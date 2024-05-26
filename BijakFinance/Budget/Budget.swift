//
//   Budget.swift
//   BijakFinance
//
//   Created by @kinderBono on 08/05/2024.
//

import SwiftUI

struct Budget: View {
    @EnvironmentObject var appModel: AppModel
    
    @State var summary: Bool = false
    @State var budget: String = ""
    @State var budgetSaved: Bool = false
    @State var spending: String = ""
    @State var spendings: Spendings = .init(spendings: [])
    @State var budgetSummary: [Spending] = []
    
    var button: [String] = ["Commitments", "Needs", "Savings"]
    @State var categoryIndex: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.creams.ignoresSafeArea()
                
                VStack {
                    ScrollView {
                        VStack(spacing: 40) {
                            VStack(spacing: 20) {
                                if !summary {
                                    HStack {
                                        Text("Enter your total budget:")
                                            .font(.title3)
                                            .bold()
                                        Spacer()
                                    }
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundStyle(.whites)
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(.blacks.opacity(0.3), lineWidth: 2)
                                        HStack {
                                            Text("RM")
                                            TextField("Enter Budget", text: $budget)
                                                .keyboardType(.numbersAndPunctuation)
                                        }
                                        .padding(10)
                                    }
                                    .frame(height: 50)
                                    Button(action: {
                                        calculateSummary()
                                        summary = true
                                    }, label: {
                                        ButtonLabel(text: "Calculate Summary")
                                            .padding(.horizontal, 40)
                                    }).disabled(budget.isEmpty)
                                } else {
                                    VStack(spacing: 20) {
                                        if !budgetSaved {
                                            HStack(spacing: 10) {
                                                Button(action: {
                                                    resetSummary()
                                                }, label: {
                                                    HStack(spacing: 5) {
                                                        Image(systemName: "chevron.left")
                                                        Text("Reset Summary")
                                                    }
                                                    .foregroundStyle(.red)
                                                })
                                                Spacer()
                                            }
                                        }
                                        SummaryChart(totalBudget: Double(budget) ?? 0, budget: $budgetSummary, spendings: spendings)
                                        if !budgetSaved {
                                            Button(action: {
                                                saveSummary()
                                            }, label: {
                                                ButtonLabel(text: "Save Budget Planning", color: .yellows)
                                                    .padding(.horizontal, 60)
                                            })
                                        } else {
                                            Button(action: {
                                                deleteSummary()
                                            }, label: {
                                                ButtonLabel(text: "Delete Budget Planning", color: .red)
                                                    .padding(.horizontal, 60)
                                            })
                                        }
                                    }
                                    .frame(height: 350)
                                }
                            }
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Add your spending:")
                                        .font(.title3)
                                        .bold()
                                    Spacer()
                                }
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .foregroundStyle(.whites)
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(.blacks.opacity(0.3), lineWidth: 2)
                                    HStack {
                                        Text("RM")
                                        TextField("Enter Spending", text: $spending)
                                            .keyboardType(.numbersAndPunctuation)
                                    }
                                    .foregroundStyle(.blacks)
                                    .padding(10)
                                    .onSubmit {
                                        addSpending()
                                    }
                                }
                                .frame(height: 50)
                                VStack {
                                    HStack {
                                        ForEach(button.indices, id: \.self) { index in
                                            if index < 2 {
                                                SelectionButton(selection: Binding(get: { categoryIndex == index }, set: { selected in
                                                    if selected {
                                                        categoryIndex = index
                                                    }
                                                }), text: button[index], color: .gray.opacity(0.3))
                                            }
                                        }
                                    }
                                    SelectionButton(selection: Binding(get: { categoryIndex == 2 }, set: { selected in
                                        if selected {
                                            categoryIndex = 2
                                        }
                                    }), text: button[2], color: .gray.opacity(0.3)).padding(.horizontal, 60)
                                }
                                .padding(.horizontal)
                                Button(action: {
                                    addSpending()
                                }, label: {
                                    ButtonLabel(text: "Deduct from Category")
                                        .padding(.horizontal, 40)
                                }).disabled(!summary)
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
                .padding(.top)
            }
            .foregroundStyle(.blacks)
            .task {
                let userBudget = appModel.dataManager.currentUser.budget
                if !userBudget.isEmpty {
                    budgetSummary = userBudget
                    budget = "\(userBudget.reduce(0) { $0 + $1.amount })"
                    budgetSaved = true
                    summary = true
                }
                spendings = appModel.dataManager.currentUser.spendings
            }
        }
    }
    
    func calculateSummary() {
        guard let totalBudget = Double(budget) else { return }
        
        budgetSummary.append(Spending(type: .commitment, amount: totalBudget * 0.35))
        budgetSummary.append(Spending(type: .need, amount: totalBudget * 0.45))
        budgetSummary.append(Spending(type: .saving, amount: totalBudget * 0.2))
    }
    
    func resetSummary() {
        summary = false
        budget = ""
        budgetSummary = []
    }
    
    func saveSummary() {
        appModel.dataManager.currentUser.budget = budgetSummary
        budgetSaved = true
        summary = true
    }
    
    func deleteSummary() {
        budgetSummary = []
        budgetSaved = false
        summary = false
        appModel.dataManager.deleteBudgetSummary()
    }
    
    func addSpending() {
        if let amount = Double(spending), let type = SpendingType(rawValue: button[categoryIndex]) {
            appModel.dataManager.addSpending(type: type, amount: amount)
            spending = ""
        }
    }
}

#Preview {
    Budget()
        .environmentObject(AppModel())
}
