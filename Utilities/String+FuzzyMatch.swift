//
//  String+FuzzyMatch.swift
//  How To
//
//  Fuzzy string matching utilities using Levenshtein distance
//

import Foundation

extension String {
    /// Compute Levenshtein distance between two strings
    nonisolated func levenshteinDistance(to target: String) -> Int {
        let sourceArray = Array(self.lowercased())
        let targetArray = Array(target.lowercased())
        
        let (m, n) = (sourceArray.count, targetArray.count)
        var matrix = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)
        
        for i in 0...m { matrix[i][0] = i }
        for j in 0...n { matrix[0][j] = j }
        
        for i in 1...m {
            for j in 1...n {
                if sourceArray[i - 1] == targetArray[j - 1] {
                    matrix[i][j] = matrix[i - 1][j - 1]
                } else {
                    let deletion = matrix[i - 1][j] + 1
                    let insertion = matrix[i][j - 1] + 1
                    let substitution = matrix[i - 1][j - 1] + 1
                    matrix[i][j] = min(deletion, insertion, substitution)
                }
            }
        }
        return matrix[m][n]
    }
    
    /// Return a similarity score between 0 and 1
    nonisolated func similarity(to other: String) -> Double {
        let maxLen = Double(max(count, other.count))
        if maxLen == 0 { return 1.0 }
        return 1.0 - (Double(self.levenshteinDistance(to: other)) / maxLen)
    }
}

