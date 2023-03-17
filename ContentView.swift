//
//  ContentView.swift
//  Freddy Chat
//
//  Created by David Koenig on 17.03.23.
//

import SwiftUI
import OpenAISwift

struct ContentView: View {
    
    @State private var search: String = ""
    
    let openAI = OpenAISwift(authToken: "<YOU'RE API KEY FROM https://platform.openai.com>")
    
    @State private var responses: [String] = []
    
    private var isFormValid: Bool {
        search.isEmpty
    }
    
    private func performSearch() {
        responses.append("You: \(search)")
        
        openAI.sendCompletion(with: search, maxTokens: 500) { result in
            switch result {
            case .success(let success):
                let response = "ChatGPT: \(success.choices.first?.text ?? "")"
                responses.append(response)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(nsImage: NSImage(named: "tornadosymbol")!)
                Text("Freddy Chat a GPT Chat App ...")
                Spacer()
                Button {
                    NSApplication.shared.terminate(nil)
                } label: {
                    Image(systemName: "xmark")
                        .font(.title)
                }.buttonStyle(.borderless)
            }
            HStack {
                TextField("Search...", text: $search).textFieldStyle(.roundedBorder)
                
                Button {
                    performSearch()
                } label: {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.title)
                }.buttonStyle(.borderless)
                    .disabled(isFormValid)
            }
            
            List(responses, id: \.self) { response in
                Text(response)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
