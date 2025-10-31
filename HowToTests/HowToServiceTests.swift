//
//  HowToServiceTests.swift
//  HowToTests
//
//  Unit tests for HowToService
//

import XCTest
@testable import How_To

final class HowToServiceTests: XCTestCase {
    var service: HowToService!
    
    override func setUp() async throws {
        service = HowToService.shared
    }
    
    func testSearchWithValidQuery() async throws {
        // Given
        let query = "cook pasta"
        
        // When
        let results = try await service.search(query: query)
        
        // Then
        XCTAssertFalse(results.isEmpty, "Search should return results")
        XCTAssertTrue(results.allSatisfy { !$0.title.isEmpty }, "All results should have titles")
        XCTAssertTrue(results.allSatisfy { !$0.blurb.isEmpty }, "All results should have blurbs")
    }
    
    func testSearchWithEmptyQuery() async throws {
        // Given
        let query = ""
        
        // When
        let results = try await service.search(query: query)
        
        // Then
        XCTAssertTrue(results.isEmpty, "Empty query should return no results")
    }
    
    func testSearchResultsContainQuery() async throws {
        // Given
        let query = "programming"
        
        // When
        let results = try await service.search(query: query)
        
        // Then
        XCTAssertFalse(results.isEmpty, "Search should return results")
        XCTAssertTrue(
            results.contains { $0.title.localizedCaseInsensitiveContains(query) },
            "At least one result should contain the search query"
        )
    }
    
    func testGetFeaturedGuides() async throws {
        // When
        let results = try await service.getFeaturedGuides()
        
        // Then
        XCTAssertEqual(results.count, 5, "Featured should return exactly 5 guides")
        XCTAssertTrue(results.allSatisfy { !$0.title.isEmpty }, "All featured guides should have titles")
        XCTAssertTrue(results.allSatisfy { !$0.blurb.isEmpty }, "All featured guides should have blurbs")
    }
    
    func testFeaturedGuidesAreUnique() async throws {
        // When
        let results = try await service.getFeaturedGuides()
        
        // Then
        let uniqueIds = Set(results.map { $0.id })
        XCTAssertEqual(uniqueIds.count, results.count, "All featured guides should have unique IDs")
    }
}

