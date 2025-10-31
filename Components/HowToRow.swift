//
//  HowToRow.swift
//  How To
//
//  Reusable row component for displaying HowToItem
//

import SwiftUI

struct HowToRow: View {
    let item: HowToItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.title)
                .font(.headline)
                .foregroundStyle(.primary)
                .lineLimit(2)
            
            Text(item.summary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            if let sourceURL = item.sourceURL {
                HStack {
                    Image(systemName: "link")
                        .font(.caption)
                    Text(sourceURL.host ?? sourceURL.absoluteString)
                        .font(.caption)
                        .lineLimit(1)
                }
                .foregroundStyle(.blue)
            }
        }
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.title). \(item.summary)")
    }
}

#Preview {
    List {
        HowToRow(item: HowToItem(
            title: "How to Build an iOS App",
            summary: "Complete guide to building your first iOS application using SwiftUI.",
            steps: ["Step 1", "Step 2"],
            sourceURL: URL(string: "https://example.com")
        ))
    }
}

