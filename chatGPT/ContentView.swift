//
//  ContentView.swift
//  chatGPT
//
//  Created by Adolfo Calderon on 1/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var prompt: String = ""
    @State private var isEditing: Bool = false
    
    @StateObject var viewModel = ChatGPTViewModel()
    
    var body: some View {
        
        VStack {
            header
            Spacer()
            ScrollView {
                Text(viewModel.responseText)
            }
            Spacer()
            Image("chatGPT")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
            Spacer()
            footer
        }
    }
    
    var title: some View {
        Button(action: {
            print("HStack was tapped!")
        }) {
            
            HStack {
                // Combining styled Text views
                Text("ChatGPT")
                    .bold()
                    .foregroundColor(.color) +
                Text(" 4")
                    .foregroundColor(.gray)
                
                Text(">")
                    .baselineOffset(1) // Adjust baselineOffset for alignment
                    .foregroundStyle(.gray)
            }
        }
        .contextMenu {
            Button(action: {
            }) {
                HStack {
                    Text("GPT-4")
                    Image(systemName: "sparkles")
                }
            }
            Button(action: {
            }) {
                HStack {
                    Text("GPT-3.5")
                    Image(systemName: "bolt.fill")
                }
            }
        }
    }
    
    var header: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "text.alignleft")

            }
            .foregroundStyle(.color)
            
            Spacer()
            title
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "square.and.pencil")

            }
            .foregroundStyle(.color)
        }
            .padding(.horizontal, 10)
    }
    
    var footer: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "camera")
                    .foregroundStyle(.color)
            }
            Button(action: {}) {
                Image(systemName: "photo")
                    .foregroundStyle(.color)
            }
            Button(action: {}) {
                Image(systemName: "folder")
                    .foregroundStyle(.color)
            }
            promptField
            Button(action: {}) {
                Image(systemName: "headphones")
                    .foregroundStyle(.color)
            }
        }
        .padding(.horizontal, 10)
    }
    
    var promptField: some View {
        ZStack {
            TextField("Message", text: $viewModel.prompt)
                .tint(.gray)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .overlay(
                    Capsule()
                        .stroke(Color.gray, lineWidth: 0.5)
                )
                .onSubmit {
                    viewModel.sendRequest()
                }
                
            HStack {
                Spacer()
                if prompt.isEmpty {
                    Button(action: {}) {
                        Image(systemName: "waveform")
                            .foregroundStyle(.gray)
                            .padding(.horizontal, 5)
                    }
                }
            }
        }
        .padding(5)
    }
}

#Preview {
    ContentView()
}
