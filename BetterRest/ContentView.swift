//
//  ContentView.swift
//  BetterRest
//
//  Created by Jan Andrzejewski on 03/06/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    var body: some View {
        VStack {
            
        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 3...12, step: 0.25)
            
        DatePicker("Please enter a date", selection: $wakeUp, in: Date.now..., displayedComponents: .hourAndMinute)
                    .labelsHidden()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
