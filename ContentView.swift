//
//  ContentView.swift
//  iOSContractorCalculator
//
//  Created by Shyam Sundar Mohan on 2/10/23.
//

import SwiftUI

struct ContentView: View {

    @State private var laborCost: String = ""
    @State private var materialCost: String = ""
    @State private var subtotal: Double = 0
    @State private var tax: Double = 0
    @State private var total: Double = 0
    @StateObject var viewModel = CalculatorViewModel()
        @State private var isShowingTaxDialog = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            HStack {
                Text("Labor:")
                    .frame(width: 80, alignment: .trailing)
                TextField("Enter labor cost", text: $laborCost)
                    .frame(width: 100)
                    .keyboardType(.decimalPad)
            }
            
            HStack {
                Text("Materials:")
                    .frame(width: 80, alignment: .trailing)
                TextField("Enter material cost", text: $materialCost)
                    .frame(width: 100)
                    .keyboardType(.decimalPad)
            }
            HStack {

                            Text("Tax Rate:").frame(width: 80, alignment: .trailing)
                Text(String(format: "%.2f%%",viewModel.taxRate )).frame(width: 100)
                    .keyboardType(.decimalPad)
                            Button("Change Rate", action: { isShowingTaxDialog = true })
                                .sheet(isPresented: $isShowingTaxDialog, content: {
                                    ChangeRateView(viewModel: viewModel)
                                })
                        }
            Button(action: {
                self.calculateCosts()
            }) {
                Text("Calculate")
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            
            HStack {
                Text("Subtotal:")
                    .frame(width: 80, alignment: .trailing)
                Text("$\(subtotal, specifier: "%.2f")").frame(width: 100)
            }
            
            HStack {
                Text("Tax:")
                    .frame(width: 80, alignment: .trailing)
                Text("$\(tax, specifier: "%.2f")").frame(width: 100)
            }
            
            HStack {
                Text("Total:")
                    .frame(width: 80, alignment: .trailing)
                Text("$\(total, specifier: "%.2f")").frame(width: 100)
            }
        }
    }
    
    func calculateCosts() {
        let labor = Double(laborCost) ?? 0
        let material = Double(materialCost) ?? 0
        
        var taxPercentage = UserDefaults.standard.double(forKey: "taxRate")
        
        subtotal = labor + material
        tax = subtotal * taxPercentage / 100
        total = subtotal + tax
    }
}
struct ChangeRateView: View {
    @ObservedObject var viewModel: CalculatorViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var newRateString = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("New Tax Rate", text: $newRateString)
                    .keyboardType(.decimalPad)
                Button("Save", action: save)
            }
            .padding()
            .navigationTitle("Change Tax Rate")
        }
    }
    
    private func save() {
        if let newRate = Double(newRateString) {
            viewModel.changeTaxRate(newRate)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

class CalculatorViewModel: ObservableObject {
    @Published var laborCost = ""
    @Published var materialCost = ""
    @Published var subtotal = ""
    @Published var taxRate = UserDefaults.standard.double(forKey: "taxRate")
    @Published var total = ""
    
    func calculateTotal() {
        if let laborCost = Double(laborCost), let materialCost = Double(materialCost) {
            let subtotal = laborCost + materialCost
            let tax = subtotal * taxRate
            let total = subtotal + tax
            
            self.subtotal = String(format: "%.2f", subtotal)
            self.total = String(format: "%.2f", total)
        }
    }
    
    func changeTaxRate(_ newRate: Double) {
        taxRate = newRate
        UserDefaults.standard.set(newRate, forKey: "taxRate")
    }
}

struct TaxSettings {
    static let taxRateKey = "taxRate"

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ContractorCalculator_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

