//
//  QtySelectionView.swift
//  GuacChain
//
//  Created by Philip Keller on 2/27/23.
//

import SwiftUI

struct QtySelectionView: View {
    @Binding var qty: Int
    var menuString: String
    
    var body: some View {
        HStack {
            Text("\(qty)")
                .font(.system(size: 48))
                .fontWeight(.heavy)
                .frame(width: 70)
            VStack (alignment: .leading, spacing: 0) {
                Text(menuString)
                    .font(.title2)
                Stepper("", value: $qty, in: 0...99)
                    .labelsHidden()
            }
        }
        .lineLimit(1)
        .minimumScaleFactor(0.5)
    }
}

struct QtySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        QtySelectionView(qty: .constant(0), menuString: "The Satoshi 'Taco' moto")
    }
}
