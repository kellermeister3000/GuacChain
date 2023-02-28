//
//  ContentView.swift
//  GuacChain
//
//  Created by Philip Keller on 2/27/23.
//

import SwiftUI

enum Currency: String, CaseIterable {
    case usd = "$ USD"
    case gdp = "£ GPB"
    case eur = "€ EUR"
}

enum Price: Double {
    case taco = 5.00
    case burrito = 8.00
    case chips = 3.00
    case horchata = 2.00
}

struct ContentView: View {
    @StateObject var currencyVM = CurrencyViewModel()
    @State private var tacoQty = 0
    @State private var burritoQty = 0
    @State private var chipsQty = 0
    @State private var horchataQty = 0
    @State private var currencySelection: Currency = .usd
    @State private var symbol = "$"
    
    var body: some View {
        VStack {
            HStack {
                Text("Guac")
                    .foregroundColor(.green)
                Text("Chain")
                    .foregroundColor(.red)
            }
            .font(Font.custom("Marker Felt", size: 48))
            .bold()
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            
            Text("The World's Tastiest Tacos - But We Only Accept Bitcoin")
                .font(Font.custom("Papyrus", size: 20))
                .multilineTextAlignment(.center)
            
            Text("🌮")
                .font(Font.custom("System", size: 80))
            
            VStack (alignment: .leading) {
                QtySelectionView(qty: $tacoQty, menuString: "The Satoshi 'Taco' moto")
                QtySelectionView(qty: $burritoQty, menuString: "Bitcoin Burrito")
                QtySelectionView(qty: $chipsQty, menuString: "Crypto Chips")
                QtySelectionView(qty: $horchataQty, menuString: "No Bubble Horchata")
            }
            
            Spacer()
            
            Picker("", selection: $currencySelection) {
                ForEach(Currency.allCases, id: \.self) { currency in
                    Text(currency.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: currencySelection) { _ in
//                symbol = "\(currencySelection.rawValue.prefix(1))"
                switch currencySelection {
                case .usd:
                    symbol = "$"
                case .gdp:
                    symbol = "£"
                case .eur:
                    symbol = "€"
                }
                print(symbol)
            }
            
            HStack (alignment: .top){
                Text("Total:")
                    .font(.title)
                VStack (alignment: .leading){
                    Text("฿ \(calcBillInBitcoin())")
                    Text("\(symbol) \(String(format: "%.2f", calcBillInCurrency()))")
                }
            }
        }
        .padding()
        .task {
            await currencyVM.getData()
        }
    }
    
    func calcBillInBitcoin() -> Double {
        let tacoTotal = Price.taco.rawValue * Double(tacoQty)
        let burritoTotal = Price.burrito.rawValue * Double(burritoQty)
        let chipsTotal = Price.chips.rawValue * Double(chipsQty)
        let horchataTotal = Price.horchata.rawValue * Double(horchataQty)
        
        let usdTotal = tacoTotal + burritoTotal + chipsTotal + horchataTotal
        
        return usdTotal / currencyVM.usdPerBTC
    }
    
    func calcBillInCurrency() -> Double {
        
        let tacoTotal = Price.taco.rawValue * Double(tacoQty)
        let burritoTotal = Price.burrito.rawValue * Double(burritoQty)
        let chipsTotal = Price.chips.rawValue * Double(chipsQty)
        let horchataTotal = Price.horchata.rawValue * Double(horchataQty)
        
        let usdTotal = tacoTotal + burritoTotal + chipsTotal + horchataTotal
        
        switch currencySelection {
        case .usd:
            return usdTotal
        case .gdp:
            return usdTotal * (currencyVM.gbpPerBTC / currencyVM.usdPerBTC)
        case .eur:
            return usdTotal * (currencyVM.eurPerBTC / currencyVM.usdPerBTC)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
