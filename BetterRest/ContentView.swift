//
//  ContentView.swift
//  BetterRest
//
//  Created by Jan Andrzejewski on 03/06/2022.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    // Alert properties
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    // Sets the default wake time to 7 am current day.
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                Text("When do you want to wake up?")
                    .font(.headline)
                
                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                }
                Section {
                Text("Desired amount of sleep")
                    .font(.headline)
                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section {
                Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 0...20)
                }
                    .alert(alertTitle, isPresented: $showingAlert) {
                        Button("Ok") { }
                    } message: {
                        Text(alertMessage)
                    }
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedTime)
            }
        }
    }
    
    func calculateBedTime() {
        do {
            // Get the model
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            // Get date's from wakeUp as dateComponents
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            // Convert them to seconds
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            // Predict
            let prediction =  try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            // Calculate the sleep time
            let sleepTime = wakeUp - prediction.actualSleep
            
            // Show a succesful alert
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            // Show an error alert
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime"
        }
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
