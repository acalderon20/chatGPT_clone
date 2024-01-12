//
//  ChatGPTViewModel.swift
//  chatGPT
//
//  Created by Adolfo Calderon on 1/12/24.
//

import Foundation

class ChatGPTViewModel: ObservableObject {
    @Published var prompt: String = ""
    @Published var responseText: String = ""

    func sendRequest() {
        Task {
            do {
                let response = try await fetchAPIData(prompt)
                DispatchQueue.main.async {
                    self.responseText = response.choices.first?.message.content ?? "No response received."
                }
            } catch {
                DispatchQueue.main.async {
                    self.responseText = "Error: \(error.localizedDescription)"
                }
                print("Error: \(error)")
            }
        }
    }
}
