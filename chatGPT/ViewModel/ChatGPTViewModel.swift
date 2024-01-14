//
//  ChatGPTViewModel.swift
//  chatGPT
//
//  Created by Adolfo Calderon on 1/12/24.
//

import Foundation

class ChatGPTViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var displayedText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isTypingEffectActive: Bool = false  // Flag for typing effect

    private let chatService: ChatService
    private var fullResponse: String = ""
    private var typingTimer: Timer?
    private var currentIndex = 0

    init(chatService: ChatService = ChatService()) {
        self.chatService = chatService
    }

    func sendRequest(with prompt: String) {
        addMessage(content: prompt, sender: .user)
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let response = try await chatService.fetchAPIData(prompt)
                DispatchQueue.main.async {
                    self.isLoading = false
                    let content = self.extractContent(from: response)
                    self.addMessage(content: content, sender: .chatGPT)
                    self.prepareResponseForDisplay(response)
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Failed to fetch data: \(error.localizedDescription)"
                }
            }
        }
    }
    
    private func extractContent(from response: ChatGPTResponse) -> String {
        return response.choices.first?.message.content ?? "No response received."
    }

    private func addMessage(content: String, sender: ChatMessage.Sender) {
        let message = ChatMessage(sender: sender, content: content)
        DispatchQueue.main.async {
            self.messages.append(message)
        }
    }

    private func prepareResponseForDisplay(_ response: ChatGPTResponse) {
        fullResponse = self.extractContent(from: response)
        startTypingEffect()
    }

    private func startTypingEffect() {
        typingTimer?.invalidate()
        currentIndex = 0
        displayedText = ""
        isTypingEffectActive = true
        typingTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
            self?.typeNextCharacter()
        }
    }

    private func typeNextCharacter() {
        if currentIndex < fullResponse.count {
            let index = fullResponse.index(fullResponse.startIndex, offsetBy: currentIndex)
            displayedText.append(fullResponse[index])
            currentIndex += 1
        } else {
            typingTimer?.invalidate()
            isTypingEffectActive = false
        }
    }

    deinit {
        typingTimer?.invalidate()
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let sender: Sender
    let content: String

    enum Sender {
        case user
        case chatGPT
    }
}
