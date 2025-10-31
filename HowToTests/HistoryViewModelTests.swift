//
//  HistoryViewModelTests.swift
//  HowToTests
//
//  Unit tests for HistoryViewModel
//

import XCTest
@testable import How_To

@MainActor
final class HistoryViewModelTests: XCTestCase {
    var viewModel: HistoryViewModel!
    let testHistoryKey = "testSearchHistory"
    
    override func setUp() async throws {
        // Clear any existing test data
        UserDefaults.standard.removeObject(forKey: testHistoryKey)
        viewModel = HistoryViewModel()
    }
    
    override func tearDown() async throws {
        UserDefaults.standard.removeObject(forKey: testHistoryKey)
        viewModel = nil
    }
    
    func testAddSearch() {
        // Given
        let query = "test query"
        
        // When
        viewModel.addSearch(query: query)
        
        // Then
        XCTAssertEqual(viewModel.historyItems.count, 1)
        XCTAssertEqual(viewModel.historyItems.first?.query, query)
    }
    
    func testAddDuplicateSearch() {
        // Given
        let query = "duplicate query"
        
        // When
        viewModel.addSearch(query: query)
        viewModel.addSearch(query: query)
        
        // Then
        XCTAssertEqual(viewModel.historyItems.count, 1, "Duplicate searches should not be added")
    }
    
    func testAddEmptySearch() {
        // Given
        let emptyQuery = "   "
        
        // When
        viewModel.addSearch(query: emptyQuery)
        
        // Then
        XCTAssertTrue(viewModel.historyItems.isEmpty, "Empty queries should not be added")
    }
    
    func testMaxHistoryItems() {
        // Given
        let maxItems = 20
        
        // When
        for i in 1...25 {
            viewModel.addSearch(query: "query \(i)")
        }
        
        // Then
        XCTAssertEqual(viewModel.historyItems.count, maxItems, "History should be limited to \(maxItems) items")
    }
    
    func testClearHistory() {
        // Given
        viewModel.addSearch(query: "test 1")
        viewModel.addSearch(query: "test 2")
        viewModel.addSearch(query: "test 3")
        
        // When
        viewModel.clearHistory()
        
        // Then
        XCTAssertTrue(viewModel.historyItems.isEmpty, "History should be empty after clearing")
    }
    
    func testHistoryOrderNewestFirst() {
        // Given
        let firstQuery = "first"
        let secondQuery = "second"
        let thirdQuery = "third"
        
        // When
        viewModel.addSearch(query: firstQuery)
        viewModel.addSearch(query: secondQuery)
        viewModel.addSearch(query: thirdQuery)
        
        // Then
        XCTAssertEqual(viewModel.historyItems[0].query, thirdQuery)
        XCTAssertEqual(viewModel.historyItems[1].query, secondQuery)
        XCTAssertEqual(viewModel.historyItems[2].query, firstQuery)
    }
    
    func testPersistenceRoundTrip() {
        // Given
        let query1 = "persistent query 1"
        let query2 = "persistent query 2"
        
        // When
        viewModel.addSearch(query: query1)
        viewModel.addSearch(query: query2)
        
        // Create new view model to test persistence
        let newViewModel = HistoryViewModel()
        
        // Then
        XCTAssertEqual(newViewModel.historyItems.count, 2, "History should persist")
        XCTAssertEqual(newViewModel.historyItems[0].query, query2)
        XCTAssertEqual(newViewModel.historyItems[1].query, query1)
    }
}

