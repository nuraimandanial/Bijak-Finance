//
//   TaxCalculator.swift
//   BijakFinance
//
//   Created by @kinderBono on 08/05/2024.
//

import SwiftUI

struct TaxCalculator: View {
    @EnvironmentObject var appModel: AppModel
    
    @State var categories = TaxCategory.categories
    @State var selectedCategory: Int = 0
    
    @State var taxAmount: String = ""
    @State var zakatAmount: String = ""
    @State var pcbAmount: String = ""
    var moreLimit: Bool {
        return (Double(taxAmount) ?? 0) > categories[selectedCategory].limit
    }
    
    @State var grossIncome: String = ""
    var taxCategoryTotals: [Category : Double] {
        var totals = [Category : Double]()
        Category.allCases.forEach { category in
            let sum = categories.filter { $0.category == category && $0.isSaved }.reduce(0) {
                $0 + $1.amount
            }
            totals[category] = sum
        }
        return totals
    }
    var totalTaxRelief: Double {
        var total: Double = 0
        categories.forEach { category in
            if category.isSaved {
                total += category.amount
            }
        }
        return total
    }
    @State var taxAmountInfo = [TaxAmountInfo]()
    var taxExemption: Double {
        return (Double(zakatAmount) ?? 0)
    }
    var totalTaxExemption: Double {
        return taxExemption + ((Double(grossIncome) ?? 0) > 35000 ? 0 : (Double(grossIncome) ?? 0) < 1 ? 0 : 400)
    }
    var taxableIncome: Double {
        let taxable = (Double(grossIncome) ?? 0) - totalTaxRelief
        return taxable <= 0 ? 0 : taxable
    }
    @State var totalTaxAmount: Double = 0
    var totalPay: Double {
        let total = totalTaxAmount - totalTaxExemption
        return total < 0 ? 0 : total
    }
    var taxRate: Double {
        return (totalPay / (taxableIncome < 1 ? 1 : taxableIncome)) * 100
    }
    
    @State var alert: Bool = false
    @State var details: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.creams.ignoresSafeArea()
                
                VStack {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 40) {
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Tax Relief")
                                        .font(.title2)
                                        .bold()
                                    Spacer()
                                }
                                HStack {
                                    Text("Tax Category")
                                    Spacer()
                                    Picker("", selection: $selectedCategory) {
                                        ForEach(categories.indices, id: \.self) { index in
                                            Text(categories[index].name).tag(index)
                                        }
                                    }
                                }
                                VStack {
                                    Textbox(hint: "Enter Amount", text: $taxAmount)
                                        .keyboardType(.numbersAndPunctuation)
                                        .onSubmit {
                                            saveTax()
                                        }
                                    HStack {
                                        Spacer()
                                        Text("(Limit \(categories[selectedCategory].limit, format: .currency(code: "MYR")))")
                                            .font(.caption)
                                            .italic()
                                    }
                                }
                                Button(action: {
                                    saveTax()
                                }, label: {
                                    ButtonLabel(text: "Save", color: moreLimit ? .gray.opacity(0.3) : .teals)
                                        .padding(.horizontal, 40)
                                })
                                .disabled(moreLimit)
                                if categories.contains(where: { $0.isSaved }) {
                                    VStack {
                                        HStack {
                                            Text("Summary")
                                                .bold()
                                            Spacer()
                                        }
                                        ScrollView {
                                            ForEach(Array(categories.enumerated()), id: \.element.self) { index, category in
                                                if category.isSaved {
                                                    HStack {
                                                        Text(category.name)
                                                        Text("\(category.amount, format: .currency(code: "MYR"))")
                                                        Spacer()
                                                        Button(action: {
                                                            selectedCategory = index
                                                            taxAmount = String(category.amount)
                                                        }, label: {
                                                            Image(systemName: "pencil")
                                                                .foregroundStyle(.yellows)
                                                        })
                                                        Button(action: {
                                                            categories[index].amount = 0
                                                            categories[index].isSaved = false
                                                        }, label: {
                                                            Image(systemName: "trash")
                                                                .foregroundStyle(.red)
                                                        })
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Tax Exemption")
                                        .font(.title2)
                                        .bold()
                                    Spacer()
                                }
                                VStack {
                                    HStack(spacing: 10) {
                                        Text("PCB")
                                            .frame(width: 60, alignment: .leading)
                                        Spacer()
                                        Textbox(hint: "Enter Amount", text: $pcbAmount)
                                            .keyboardType(.numbersAndPunctuation)
                                    }
                                    HStack(spacing: 10) {
                                        Text("Zakat")
                                            .frame(width: 60, alignment: .leading)
                                        Spacer()
                                        Textbox(hint: "Enter Amount", text: $zakatAmount)
                                            .keyboardType(.numbersAndPunctuation)
                                    }
                                }
                            }
                            
                            VStack(spacing: 20) {
                                HStack {
                                    Text("Tax Rates")
                                        .font(.title2)
                                        .bold()
                                    Spacer()
                                }
                                VStack {
                                    Textbox(hint: "Enter Gross Income", text: $grossIncome)
                                        .keyboardType(.numbersAndPunctuation)
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundStyle(.whites)
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(.blacks.opacity(0.3), lineWidth: 2)
                                        HStack {
                                            Text("Tax Relief")
                                            Spacer()
                                            Text("\(totalTaxRelief, format: .currency(code: "MYR"))")
                                        }
                                        .padding(10)
                                    }
                                    .frame(height: 50)
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundStyle(.whites)
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(.blacks.opacity(0.3), lineWidth: 2)
                                        HStack {
                                            Text("Tax Exemption")
                                            Spacer()
                                            Text("\(totalTaxExemption, format: .currency(code: "MYR"))")
                                        }
                                        .padding(10)
                                    }
                                    .frame(height: 50)
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundStyle(.turqois.opacity(0.3))
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(.blacks.opacity(0.3), lineWidth: 2)
                                        HStack {
                                            Text("Average Tax Rate")
                                            Spacer()
                                            Text("\(taxRate, specifier: "%.1f")%")
                                        }
                                        .padding(10)
                                    }
                                    .frame(height: 50)
                                }
                                .padding(.horizontal)
                                
                                Button(action: {
                                    totalTaxAmount = calculateTotalTax(income: taxableIncome)
                                    alert = true
                                }, label: {
                                    ButtonLabel(text: "Calculate", color: .yellows)
                                        .padding(.horizontal, 40)
                                })
                                .alert(isPresented: $alert) {
                                    Alert(title: Text("Total Tax Due"), message: Text("\(totalPay, format: .currency(code: "MYR"))"), primaryButton: .cancel(), secondaryButton: .default(Text("Show Details"), action: {
                                        details = true
                                    }))
                                }
                                .fullScreenCover(isPresented: $details) {
                                    TaxSummary(grossIncome: Double(grossIncome) ?? 0, taxRelief: totalTaxRelief, taxReliefCategory: taxCategoryTotals, taxableIncome: taxableIncome, taxAmount: totalTaxAmount, taxAmountInfo: taxAmountInfo, taxExemption: totalTaxExemption, totalPay: totalPay, taxRate: taxRate, pcbAmount: Double(pcbAmount) ?? 0)
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                }
            }
            .foregroundStyle(.blacks)
        }
    }
    
    func saveTax() {
        if !moreLimit && (Double(taxAmount) ?? 0) > 0 {
            categories[selectedCategory].amount = Double(taxAmount) ?? 0
            categories[selectedCategory].isSaved = true
            taxAmount = ""
        }
    }
    
    func calculateTotalTax(income: Double) -> Double {
        let brackets = [
            TaxRate(limit: 5000, rate: 0, maximum: 0),
            TaxRate(limit: 20000, rate: 0.01, maximum: 150, previousTax: 0),
            TaxRate(limit: 35000, rate: 0.03, maximum: 450, previousTax: 150),
            TaxRate(limit: 50000, rate: 0.06, maximum: 900, previousTax: 600),
            TaxRate(limit: 70000, rate: 0.11, maximum: 2200, previousTax: 1500),
            TaxRate(limit: 100000, rate: 0.19, maximum: 5700, previousTax: 3700),
            TaxRate(limit: 400000, rate: 0.25, maximum: 75000, previousTax: 9400),
            TaxRate(limit: 600000, rate: 0.26, maximum: 52000, previousTax: 84400),
            TaxRate(limit: 2000000, rate: 0.28, maximum: 392000, previousTax: 13640),
            TaxRate(limit: .infinity, rate: 0.3, maximum: .infinity, previousTax: 528400),
        ]
        
        var tax = 0.0
        var previousLimit = 0.0
        
        for bracket in brackets {
            if income <= 0 { break }
            
            let currentTaxable = min(income, bracket.limit) - previousLimit
            let currentTax = currentTaxable * bracket.rate
            let text = String(format: "%.0f x %.0f%%", currentTaxable, bracket.rate * 100)
            let newInfo = TaxAmountInfo(text: text, amount: currentTax)
            taxAmountInfo.append(newInfo)

            tax += currentTax
            if income < bracket.limit {
                break
            }
            previousLimit = bracket.limit
        }
        return max(tax, 0)
    }
}

#Preview {
    TaxCalculator()
        .environmentObject(AppModel())
}
