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
            ZStack {
                conversationView
                Image("chatGPT")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .opacity(viewModel.displayedText.isEmpty ? 1 : 0)
                }
            Spacer()
            footer
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
            .padding(.bottom, 10)
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
                Text(" 3.5")
                    .foregroundColor(.gray)
                
                Text(">")
                    .baselineOffset(1) // Adjust baselineOffset for alignment
                    .foregroundStyle(.gray)
            }
        }
        .contextMenu {
            contextMenuItem(title: "GPT-4", imageName: "sparkles")
            contextMenuItem(title: "GPT-3.5", imageName: "bolt.fill")
        }
    }

    func contextMenuItem(title: String, imageName: String) -> some View {
        Button(action: {
            // Placeholder for future action
        }) {
            HStack {
                Text(title)
                Image(systemName: imageName)
            }
        }
    }

    var conversationView: some View {
        ScrollView {
            ForEach(viewModel.messages.indices, id: \.self) { index in
                let isUser = viewModel.messages[index].sender == .user
                let isLastAndTyping = index == viewModel.messages.count - 1 && viewModel.isTypingEffectActive
                let messageContent = isLastAndTyping ? viewModel.displayedText : viewModel.messages[index].content

                MessageView(isUser: isUser, messageContent: messageContent)
                }
            }
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
            TextField("Message", text: $prompt)
                .tint(.gray)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .overlay(
                    Capsule()
                        .stroke(Color.gray, lineWidth: 0.5)
                )
                .onSubmit {
                    viewModel.sendRequest(with: prompt)
                    prompt = ""
                    
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

struct MessageView: View {
    var isUser: Bool
    var messageContent: String
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                iconView
                    .frame(width: 20, height: 20)
                    .alignmentGuide(.top) { _ in 10 } // Adjust this value as needed
                Spacer()
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(isUser ? "You" : "ChatGPT")
                        .fontWeight(.semibold)
                        
                    Spacer()
                }
                HStack {
                    Text(messageContent)
                        .foregroundStyle(.color)
                    Spacer()
                }
            }
        }
        .padding()
    }
    
    var iconView: some View {
        Group {
            if isUser {
                Circle()
                    .fill(.mint)
            } else {
                Image("chatGPT")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}


#Preview {
    ContentView()
}
