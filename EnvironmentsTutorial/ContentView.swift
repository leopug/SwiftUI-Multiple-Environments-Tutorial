//
//  ContentView.swift
//  EnvironmentsTutorial
//
//  Created by Leonardo Maia Pugliese on 27/02/2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ExampleViewModel()
    @AppStorage("isQA") var isQA = false
    
    var body: some View {
        VStack {
            if isQA {
                Text("IS QA")
                    .font(.title)
            }
            
            Text("Fetch From Service")
            Button("Command Line") {
                viewModel.fetchInfoCommandLine()
            }
            .buttonStyle(.borderedProminent)
            .padding()

            Button("Build Configuration") {
                viewModel.fetchInfoBuildConfiguration()
            }
            .buttonStyle(.borderedProminent)
            .padding()
            
            Button("Environment Variables") {
                viewModel.fetchEnvironmentVariables()
            }
            .buttonStyle(.borderedProminent)
            .padding()

            Button("User Defaults") {
                viewModel.fetchInfoUserDefaults()
            }
            .buttonStyle(.borderedProminent)
            .padding()

            Text(viewModel.resultCommandLine)
            Text(viewModel.resultBuildConfiguration)
            Text(viewModel.resultBaseURL)
            Text(viewModel.resultUserDefaults)
            
        }
        .padding()
    }
}

class ExampleViewModel: ObservableObject {
    @Published var resultCommandLine = ""
    @Published var resultBuildConfiguration = ""
    @Published var resultUserDefaults = ""
    @Published var resultBaseURL = "prod-holyswift.app"
    
    func fetchInfoCommandLine()  {
        if checkIfCommandLineContains("-qa") {
            resultCommandLine = "Command Line qa"
        }
        
        if checkIfCommandLineContains("-prod") {
            resultCommandLine = "Command Line prod"
        }
        
        if checkIfCommandLineContains("-staging") {
            resultCommandLine = "Command Line staging"
        }
    }

    private func checkIfCommandLineContains(_ value: String) -> Bool {
        CommandLine.arguments.contains(value)
    }
    
    func fetchInfoBuildConfiguration() {
        #if DEBUG
        resultBuildConfiguration = "build configuration QA"
        #else
        resultBuildConfiguration = "build configuration Release"
        #endif
        
        #if STAGING
        resultBuildConfiguration = "build configuration Staging"
        #endif
    }
    
    func fetchEnvironmentVariables() {
        if let qaBaseUrl = ProcessInfo.processInfo.environment["base-url"] {
            resultBaseURL = qaBaseUrl
        }
    }
    
    func fetchInfoUserDefaults() {
        resultUserDefaults = UserDefaults.standard.bool(forKey: "isQA") ? "is QA!" : "not QA!"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
