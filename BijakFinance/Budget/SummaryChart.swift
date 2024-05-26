//
//   SummaryChart.swift
//   BijakFinance
//
//   Created by @kinderBono on 16/05/2024.
//   

import SwiftUI
import Charts

struct SummaryChart: View {
    var totalBudget: Double
    @Binding var budget: [Spending]
    @ObservedObject var spendings: Spendings
    var color: [Color] = [.yellows, .teals, .red.opacity(0.7)]
    
    var body: some View {
        Chart {
            ForEach(budget.indices, id: \.self) { index in
                let data = budget[index]
                let spending = spendings.spendings.first(where: { $0.type == data.type })
                
                SectorMark(
                    angle: .value("Amount", data.amount),
                    innerRadius: .ratio(0.65),
                    angularInset: 2
                )
                .foregroundStyle(color[index].opacity(0.8))
                .annotation(position: .overlay) {
                    let balance = data.amount - (spending?.amount ?? 0)
                    VStack {
                        Text(data.type.rawValue())
                            .bold()
                        Text("\(data.amount, format: .currency(code: "MYR"))")
                        Text("(\(abs(balance), format: .currency(code: "MYR")))")
                            .font(.caption)
                            .foregroundStyle(balance > 0 ? .green : .red)
                    }
                    .foregroundStyle(.blacks)
                    .padding(5)
                    .font(.callout)
                    .background {
                        ZStack {
                            Rectangle().foregroundStyle(.whites)
                            Rectangle().stroke(.blacks.opacity(0.3), lineWidth: 2)
                        }
                    }
                }
            }
        }
        .foregroundStyle(.blacks)
        .chartLegend(.hidden)
        .chartBackground { _ in
            VStack {
                Text("Budget")
                    .bold()
                Text("\(totalBudget, format: .currency(code: "MYR"))")
            }
            .foregroundStyle(.blacks)
        }
    }
}
