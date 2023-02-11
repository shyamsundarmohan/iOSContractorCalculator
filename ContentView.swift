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
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Labor:")
                    .frame(width: 80, alignment: .trailing)
                TextField("Enter labor cost", text: $laborCost)
                    .frame(width: 100)
                    .keyboardType(.decimalPad)
            }
            .padding(.bottom, 10)
            
            HStack {
                Text("Materials:")
                    .frame(width: 80, alignment: .trailing)
                TextField("Enter material cost", text: $materialCost)
                    .frame(width: 100)
                    .keyboardType(.decimalPad)
            }
            .padding(.bottom, 20)
            
            Button(action: {
                self.calculateCosts()
            }) {
                Text("Calculate")
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            .padding(.bottom, 20)
            
            HStack {
                Text("Subtotal:")
                    .frame(width: 80, alignment: .trailing)
                Text("$\(subtotal, specifier: "%.2f")")
            }
            
            HStack {
                Text("Tax:")
                    .frame(width: 80, alignment: .trailing)
                Text("$\(tax, specifier: "%.2f")")
            }
            
            HStack {
                Text("Total:")
                    .frame(width: 80, alignment: .trailing)
                Text("$\(total, specifier: "%.2f")")
            }
        }
        .padding()
    }
    
    func calculateCosts() {
        let labor = Double(laborCost) ?? 0
        let material = Double(materialCost) ?? 0
        subtotal = labor + material
        tax = subtotal * 0.05
        total = subtotal + tax
    }
}

struct ContractorCalculator_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

