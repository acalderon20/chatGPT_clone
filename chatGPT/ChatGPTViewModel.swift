//
//  ChatGPTViewModel.swift
//  chatGPT
//
//  Created by Adolfo Calderon on 1/12/24.
//

import Foundation

class ChatGPTViewModel: ObservableObject {
    @Published var responseText: String = ""

    private var typingTimer: Timer?
    private var fullResponse: String = ""
    private var currentIndex = 0
    private var isTyping = false

    func sendRequest(with prompt: String) {
        Task {
            do {
                print("Prompt sent: \(prompt)")
                let response = try await fetchAPIData(prompt)
                DispatchQueue.main.async {
                    self.prepareTypingEffect(with: response.choices.first?.message.content ?? "No response received.")
                }
            } catch {
                DispatchQueue.main.async {
                    self.responseText = "Error: \(error.localizedDescription)"
                }
                print("Error: \(error)")
            }
        }
    }
    private func prepareTypingEffect(with response: String) {
        fullResponse = response
        currentIndex = 0
        responseText = ""
        isTyping = true
        startTypingEffect()
    }

    private func startTypingEffect() {
        typingTimer?.invalidate()
        typingTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
            DispatchQueue.main.async {
                self?.typeNextCharacter()
            }
        }
    }

    private func typeNextCharacter() {
        if currentIndex < fullResponse.count {
            let index = fullResponse.index(fullResponse.startIndex, offsetBy: currentIndex)
            responseText.append(fullResponse[index])
            currentIndex += 1
        } else {
            isTyping = false
            typingTimer?.invalidate()
        }
    }

    deinit {
        typingTimer?.invalidate()
    }
}
