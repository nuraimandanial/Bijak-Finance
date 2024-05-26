//
//   TaxSummary.swift
//   BijakFinance
//
//   Created by @kinderBono on 10/05/2024.
//   

import SwiftUI
import UIKit

struct TaxSummary: View {
    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) var dismiss
    
    var grossIncome: Double = 0
    var taxRelief: Double = 0
    var taxReliefCategory: [Category : Double] = [:]
    var taxableIncome: Double = 0
    var taxAmount: Double = 0
    var taxAmountInfo: [TaxAmountInfo] = []
    var taxExemption: Double = 0
    var totalPay: Double = 0
    var taxRate: Double = 0
    var pcbAmount: Double = 10
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.creams.ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Income Tax Summary")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding()
                    
                    TaxSummaryContent(grossIncome: grossIncome, taxRelief: taxRelief, taxReliefCategory: taxReliefCategory, taxableIncome: taxableIncome, taxAmount: taxAmount, taxAmountInfo: taxAmountInfo, taxExemption: taxExemption, totalPay: totalPay, taxRate: taxRate, pcbAmount: pcbAmount)
                    
                    VStack {
                        Button(action: {
                            dismiss()
                        }, label: {
                            ButtonLabel(text: "Back")
                                .padding(.horizontal, 40)
                        })
                        Button(action: {
                            if let image = captureImage(of: TaxSummaryContent(grossIncome: grossIncome, taxRelief: taxRelief, taxReliefCategory: taxReliefCategory, taxableIncome: taxableIncome, taxAmount: taxAmount, taxAmountInfo: taxAmountInfo, taxExemption: taxExemption, totalPay: totalPay, taxRate: taxRate, pcbAmount: pcbAmount)) {
                                printImage(image)
                            }
                        }, label: {
                            ButtonLabel(text: "Print", color: .yellows)
                                .padding(.horizontal, 40)
                        })
                        Button(action: {
                            if let image = captureImage(of: TaxSummaryContent(grossIncome: grossIncome, taxRelief: taxRelief, taxReliefCategory: taxReliefCategory, taxableIncome: taxableIncome, taxAmount: taxAmount, taxAmountInfo: taxAmountInfo, taxExemption: taxExemption, totalPay: totalPay, taxRate: taxRate, pcbAmount: pcbAmount)) {
                                saveImage(image)
                            }
                        }, label: {
                            ButtonLabel(text: "Save", color: .yellows)
                                .padding(.horizontal, 40)
                        })
                    }
                }
            }
            .foregroundStyle(.blacks)
        }
    }
    
    func captureImage<T: View>(of view: T) -> UIImage? {
        let controller = UIHostingController(rootView: view)
        let targetSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        controller.view.frame = CGRect(origin: .zero, size: targetSize)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
    func saveImage(_ image: UIImage?) {
        guard let image = image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    func printImage(_ image: UIImage?) {
        guard let image = image else {
            return
        }
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = .photo
        printInfo.jobName = "Print Tax Summary"
        
        let printerController = UIPrintInteractionController.shared
        printerController.printInfo = printInfo
        printerController.printingItem = image
        printerController.present(animated: true, completionHandler: nil)
    }
}

#Preview {
    TaxSummary()
        .environmentObject(AppModel())
}

struct TaxSummaryContent: View {
    var grossIncome: Double
    var taxRelief: Double
    var taxReliefCategory: [Category : Double]
    var taxableIncome: Double
    var taxAmount: Double
    var taxAmountInfo: [TaxAmountInfo]
    var taxExemption: Double
    var totalPay: Double
    var taxRate: Double
    var pcbAmount: Double
    
    var body: some View {
        ZStack {
            Rectangle()
                .stroke(.blacks.opacity(0.3), lineWidth: 2)
            ScrollView {
                VStack(spacing: 25) {
                    VStack(spacing: 15) {
                        HStack {
                            Text("Gross Income Before Deduction")
                                .bold()
                            Spacer()
                            Text("\(grossIncome, format: .currency(code: "MYR"))")
                        }
                        VStack(spacing: 5) {
                            HStack {
                                Text("Tax Deductions")
                                Spacer()
                                Text("- \(taxRelief, format: .currency(code: "MYR"))")
                            }
                            .foregroundStyle(.red.opacity(0.8))
                            VStack {
                                ForEach(Category.allCases, id: \.self) { category in
                                    if let total = taxReliefCategory[category] {
                                        HStack {
                                            Text("\(category.rawValue()) Relief")
                                            Spacer()
                                            Text("\(total, format: .currency(code: "MYR"))")
                                        }
                                        .font(.caption)
                                        .foregroundStyle(.blacks.opacity(0.5))
                                    }
                                }
                            }
                            .padding(.leading)
                        }
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.blacks.opacity(0.5))
                    VStack(spacing: 15) {
                        HStack {
                            Text("Taxable Income")
                            Spacer()
                            Text("\(taxableIncome, format: .currency(code: "MYR"))")
                        }
                        HStack {
                            Text("Tax Amount")
                            Spacer()
                            Text("\(taxAmount, format: .currency(code: "MYR"))")
                        }
                        .bold()
                        VStack(spacing: 0) {
                            ForEach(taxAmountInfo) { info in
                                HStack {
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        Text("\(info.text) = ")
                                    }
                                    VStack {
                                        Text("\(info.amount, specifier: "%.0f")")
                                            .frame(width: 80, alignment: .trailing)
                                    }
                                }
                                .font(.caption)
                                .foregroundStyle(.blacks.opacity(0.5))
                            }
                        }
                        HStack {
                            Text("Tax Exemption")
                            Spacer()
                            Text("- \(taxExemption, format: .currency(code: "MYR"))")
                        }
                        .foregroundStyle(.red.opacity(0.8))
                    }
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(.blacks)
                    VStack(spacing: 15) {
                        HStack {
                            Text("Tax You Should Pay")
                            Spacer()
                            Text("\(totalPay, format: .currency(code: "MYR"))")
                        }
                        .bold()
                        HStack {
                            Text("Average Tax Rate")
                            Spacer()
                            Text("\(taxRate, specifier: "%.1f")%")
                        }
                        Spacer()
                        if !pcbAmount.isZero {
                            let finalTotal = totalPay - pcbAmount
                            VStack(spacing: 0) {
                                Text("As you have paid \(pcbAmount, format: .currency(code: "MYR")) for PCB,")
                                if finalTotal < 0 {
                                    Group {
                                        Text("you will entitle tax fund of ") +
                                        Text("\(abs(finalTotal), format: .currency(code: "MYR"))")
                                            .foregroundStyle(.green)
                                    }
                                } else {
                                    Group {
                                        Text("your remaining tax to pay is ") +
                                        Text("\(abs(finalTotal), format: .currency(code: "MYR"))")
                                            .foregroundStyle(.red)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(30)
            }
            .foregroundStyle(.blacks)
        }
        .padding()
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
}
