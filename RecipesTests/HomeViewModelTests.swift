import Foundation
import XCTest

@testable import Recipes

enum MockError: Error {
    case mock
}

class RecipeRepositoryMock: RecipeRepositoryProtocol {
    
    var fetchRecipesResult: [Recipe] = []
    var didFetchRecipes = 0
    var shouldFetchRecipesThrowError = false
    
    func fetchRecipes() async throws -> [Recipes.Recipe] {
        didFetchRecipes += 1
        
        if shouldFetchRecipesThrowError {
            throw MockError.mock
        }
        
        return fetchRecipesResult
    }
    
    var didSearchWithQuery: [String] = []
    var shouldFailSearchWithQuery = false
    var searchWithQueryResult: [Recipe] = []
    
    func search(with query: String) async throws -> [Recipes.Recipe] {
        didSearchWithQuery.append(query)
        
        if shouldFailSearchWithQuery {
            throw MockError.mock
        }
        
        return searchWithQueryResult
    }
}

extension Recipe {
    static var mock: Recipe {
        Recipe(id: "1", name: "Beans", imageUrl: "", duration: 10)
    }
}

class HomeViewModelTests: XCTestCase {
    
    private var viewModel:HomeViewModel!
    private var repository:RecipeRepositoryMock!
    
    override func setUp() async throws {
        try await super.setUp()
        
        repository = RecipeRepositoryMock()
        viewModel = HomeViewModel(repository: repository)
    }
    
    func test_whenFetchSucceds_thenSaveResults() async {
        // given
        let repositoryResult = [Recipe.mock]
        repository.fetchRecipesResult = repositoryResult
        
        // when
        await viewModel.loadRecipes()
        
        // then
        XCTAssertEqual(viewModel.recipes.count, repositoryResult.count)
        XCTAssertEqual(viewModel.recipes.map { $0.name }, repositoryResult.map { $0.name })
        XCTAssertEqual(repository.didFetchRecipes, 1)
    }
    
    func test_whenFetchFails_thenShowError() async {
        // given
        repository.shouldFetchRecipesThrowError = true
        
        let expectation = self.expectation(description: "showError")
        var errorText: String?
        viewModel.showError = { text in
            expectation.fulfill()
            errorText = text
        }
        
        // when
        await viewModel.loadRecipes()
        
        //then
        await fulfillment(of: [expectation], timeout: 0.5)
        XCTAssertEqual(errorText, "error.fetch-recipes".localized + " " + MockError.mock.localizedDescription)
    }
    
    func test_whenSearchBarSucceeds_thenShowResults() async {
        //given
        let query = "query"
        let mockResults = [Recipe.mock]
        repository.searchWithQueryResult = mockResults
        
        // when
        await viewModel.searchRecipes(query: query)
        
        //then
        XCTAssertEqual(repository.didSearchWithQuery.count, 1)
        XCTAssertEqual(repository.didSearchWithQuery[0], query)
        XCTAssertEqual(viewModel.recipes, mockResults)
    }
    
    func test_whenSearchFails_thenShowResults() async {
        // given
        let query = "query"
        repository.shouldFailSearchWithQuery = true
        
        let expectation = self.expectation(description: "showError")
        var showErrorText: String?
        viewModel.showError = { text in
            expectation.fulfill()
            showErrorText = text
        }
        
        // when
        await viewModel.searchRecipes(query: query)
        
        // then
        await fulfillment(of: [expectation], timeout: 0.5)
        XCTAssertTrue(showErrorText!.contains("error.search-recipes".localized))
    }
    
    func test_whenSeachWithEmptyQuery_thenFetchALlRecipes() async {
        // given
        let query = ""
        let mockResults = [Recipe.mock]
        repository.fetchRecipesResult = mockResults
        
        // when
        await viewModel.searchRecipes(query: query)
        
        // then
        XCTAssertEqual(repository.didSearchWithQuery.count, 0)
        XCTAssertEqual(repository.didFetchRecipes, 1)
        XCTAssertEqual(viewModel.recipes, mockResults)
    }
}
