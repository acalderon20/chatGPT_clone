//
//  ChatService.swift
//  chatGPT
//
//  Created by Adolfo Calderon on 1/12/24.
//

import Foundation

// Structure to define the request format
struct ChatGPTRequest: Encodable {
    let model: String
    let messages: [Message]
    let maxTokens: Int

    struct Message: Encodable {
        let role: String
        let content: String
    }

    enum CodingKeys: String, CodingKey {
        case model, messages
        case maxTokens = "max_tokens"
    }
}

// Structure to decode the response
struct ChatGPTResponse: Decodable {
    let id: String
    let choices: [Choice]
    
    struct Choice: Decodable {
        let message: Message
    }

    struct Message: Decodable {
        let role: String
        let content: String
    }
}

func fetchAPIData(_ prompt: String) async throws -> ChatGPTResponse {
    let url = URL(string: "https://api.openai.com/v1/chat/completions")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    // Fetch the API key from environment variables
    if let apiKey = ProcessInfo.processInfo.environment["API_KEY"] {
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    } else {
        // Handle the case where the API key is not found
        print("API_KEY not found in environment variables")
        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "API_KEY not found"])
    }

    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    

    let parameters = ChatGPTRequest(
        model: "gpt-3.5-turbo",
        messages: [ChatGPTRequest.Message(role: "system", content: prompt)],
        maxTokens: 60
    )
    

    let encoder = JSONEncoder()
    if let jsonData = try? encoder.encode(parameters),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("JSON Request: \(jsonString)")
            request.httpBody = jsonData
        }
    
    return try await fetchResponse(with: request)
}

func fetchResponse(with request: URLRequest) async throws -> ChatGPTResponse {
    let (data, _) = try await URLSession.shared.data(for: request)
    if let rawJSONString = String(data: data, encoding: .utf8) {
        print("Raw JSON Response: \(rawJSONString)")
    }
    return try JSONDecoder().decode(ChatGPTResponse.self, from: data)
    
}




