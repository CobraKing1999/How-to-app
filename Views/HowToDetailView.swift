//
//  HowToDetailView.swift
//  How To
//
//  Detail view showing how-to guide with steps in-app
//

import SwiftUI
import SafariServices

struct HowToDetailView: View {
    let item: HowToItem
    @State private var showingSafari = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(item.title)
                    .font(.largeTitle.bold())
                    .accessibilityAddTraits(.isHeader)
                
                if !item.summary.isEmpty {
                    Text(item.summary)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                
                // Steps (numbered)
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(item.steps.enumerated()), id: \.offset) { idx, step in
                        HStack(alignment: .firstTextBaseline, spacing: 12) {
                            Text("\(idx + 1).")
                                .font(.headline)
                                .monospacedDigit()
                            Text(step)
                                .font(.body)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Step \(idx + 1). \(step)")
                    }
                }
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                // Optional source button
                if let url = item.sourceURL {
                    Button {
                        showingSafari = true
                    } label: {
                        Label("View Source", systemImage: "safari")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingSafari) {
            if let url = item.sourceURL {
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        }
    }
}

// Simple SFSafariViewController bridge
struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = false
        let controller = SFSafariViewController(url: url, configuration: config)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // No updates needed
    }
}

#Preview {
    NavigationStack {
        HowToDetailView(item: HowToItem(
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
        ))
    }
}

