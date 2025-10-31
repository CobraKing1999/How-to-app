//
//  HowToService.swift
//  How To
//
//  Service layer for fetching how-to guides and AI-powered assistance
//

import Foundation

actor HowToService {
    static let shared = HowToService()
    
    // MARK: - API Configuration
    private let backendURL = "http://192.168.0.32:3000" // Local development server
    
    private init() {}
    
    // MARK: - Helper Methods
    /// Creates a search URL as fallback when no specific URL is available
    static func makeSearchURL(for query: String) -> URL {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "https://duckduckgo.com/?q=\(encodedQuery)")!
    }
    
    // MARK: - AI Question Method
    struct AskRequest: Encodable {
        let question: String
    }
    
    struct AskResponse: Decodable {
        let answer: String
        let source_url: String?
    }
    
    /// Ask a question using AI-powered backend
    /// - Parameter question: The user's question
    /// - Returns: AI-generated answer
    func ask(_ question: String) async throws -> String {
        guard let url = URL(string: "\(backendURL)/ask") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(AskRequest(question: question))
        request.timeoutInterval = 30 // 30 second timeout for AI responses
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            guard httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let decoded = try JSONDecoder().decode(AskResponse.self, from: data)
            // You can use decoded.source_url in the UI if needed
            return decoded.answer
        } catch {
            // Return user-friendly error message
            throw NSError(
                domain: "HowToService",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to get AI response. Please try again."]
            )
        }
    }
    
    // TODO: Replace with Firestore/REST API call
    func search(query: String) async throws -> [HowToItem] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        // Get all available guides (combine featured + additional samples)
        let allGuides = await getAllGuides()
        
        guard !query.isEmpty else {
            return []
        }
        
        // Fuzzy search with threshold
        let threshold = 0.3  // Tune: 0.3 = loose (good for typos), 0.5 = balanced, 0.8 = strict
        let results = allGuides.filter { item in
            let titleScore = item.title.similarity(to: query)
            let summaryScore = item.summary.similarity(to: query)
            return titleScore > threshold || summaryScore > threshold
        }
        
        // Sort by relevance (best matches first)
        let sortedResults = results.sorted { first, second in
            let firstScore = max(first.title.similarity(to: query), first.summary.similarity(to: query))
            let secondScore = max(second.title.similarity(to: query), second.summary.similarity(to: query))
            return firstScore > secondScore
        }
        
        return sortedResults
    }
    
    /// Get all available guides from all sources
    private func getAllGuides() async -> [HowToItem] {
        // Featured guides
        let featured = (try? await getFeaturedGuides()) ?? []
        
        // Additional search samples
        let additional: [HowToItem] = [
            HowToItem(
                title: "How to Brew an Espresso",
                summary: "Fast, balanced shot using a home machine.",
                steps: [
                    "Preheat machine and portafilter 10–15 minutes.",
                    "Grind 18g coffee; aim for fine, table-salt texture.",
                    "Distribute & tamp level (≈30 lbs).",
                    "Lock in; start shot. Target 36–40g out in 25–30s.",
                    "Taste; adjust grind/timing for balance."
                ],
                sourceURL: URL(string: "https://en.wikipedia.org/wiki/Espresso")
            ),
            HowToItem(
                title: "How to Change a Flat Tire",
                summary: "Safe roadside swap in under 15 minutes.",
                steps: [
                    "Park safe; hazards on; engage parking brake.",
                    "Loosen lug nuts 1/4 turn before lifting.",
                    "Jack at the pinch weld; lift until tire clears.",
                    "Remove nuts & wheel; mount spare; hand-tighten.",
                    "Lower; torque in star pattern; stow tools; check PSI."
                ],
                sourceURL: nil
            )
        ]
        
        return featured + additional
    }
    
    // TODO: Replace with Firestore/REST API call
    func getFeaturedGuides() async throws -> [HowToItem] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 300_000_000) // 0.3 seconds
        
        return [
            HowToItem(
                title: "How to Build an iOS App",
                summary: "Complete guide to building your first iOS application using SwiftUI.",
                steps: [
                    "Install Xcode from the Mac App Store.",
                    "Create a new project using the iOS App template.",
                    "Design your UI using SwiftUI's declarative syntax.",
                    "Implement your app logic using Swift.",
                    "Test on simulator and real device.",
                    "Submit to App Store when ready."
                ],
                sourceURL: URL(string: "https://developer.apple.com/tutorials/app-dev-training")!
            ),
            HowToItem(
                title: "How to Cook Perfect Pasta",
                summary: "Master the art of cooking pasta al dente.",
                steps: [
                    "Bring large pot of salted water to rolling boil.",
                    "Add pasta and stir immediately to prevent sticking.",
                    "Cook 1-2 minutes less than package directions.",
                    "Reserve 1 cup pasta water before draining.",
                    "Finish pasta in sauce with reserved water."
                ],
                sourceURL: URL(string: "https://www.seriouseats.com/how-to-cook-pasta")!
            ),
            HowToItem(
                title: "How to Start Investing",
                summary: "Learn the basics of investing and building wealth.",
                steps: [
                    "Assess your financial situation and goals.",
                    "Build an emergency fund (3-6 months expenses).",
                    "Start with index funds or ETFs for diversification.",
                    "Open a brokerage account or use a robo-advisor.",
                    "Set up automatic contributions.",
                    "Review and rebalance your portfolio regularly."
                ],
                sourceURL: URL(string: "https://www.investor.gov/introduction-investing/getting-started")!
            ),
            HowToItem(
                title: "How to Learn a New Language",
                summary: "Proven strategies to become fluent.",
                steps: [
                    "Choose a language you're passionate about.",
                    "Use apps like Duolingo or Babbel for basics.",
                    "Practice daily, even if just 15 minutes.",
                    "Immerse yourself with movies, music, and books.",
                    "Find a conversation partner or tutor.",
                    "Travel to a country where it's spoken (if possible).",
                    "Be patient and celebrate small wins."
                ],
                sourceURL: URL(string: "https://www.fluentu.com/blog/learn-new-language-fast")!
            ),
            HowToItem(
                title: "How to Improve Your Photography",
                summary: "Take stunning photos with professional tips.",
                steps: [
                    "Learn basic composition rules (rule of thirds, leading lines).",
                    "Understand your camera's settings (ISO, aperture, shutter).",
                    "Shoot during golden hour for best natural light.",
                    "Practice framing and finding interesting angles.",
                    "Edit your photos to enhance (not over-edit).",
                    "Study great photographers for inspiration.",
                    "Take lots of photos - practice makes perfect."
                ],
                sourceURL: URL(string: "https://photographylife.com/photography-tips-for-beginners")!
            )
        ]
    }
}

