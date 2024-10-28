//
//  SwiftUIView.swift
//  NotificationInSwiftUi
//
//  Created by Muhammad Zeeshan on 28/10/2024.
//

import SwiftUI

enum NextView: String, Identifiable {
    case promo, renew
    
    var id: String {
        self.rawValue
    }
    
    @ViewBuilder
    func view() -> some View {
        switch self {
        case .promo:
            Text("Promo View")
                .font(.largeTitle)
        case .renew:
            VStack {
                Text("Renew View")
                    .font(.largeTitle)
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 128))
            }
        }
    }
}
