import Foundation
import XCTest

@testable import Recipes

class LocalRecipeDataSourceMock: LocalRecipeDataSourceProtocol {
    
    var fetchRecipesResult: [RecipeDTO] = []
    
    func fetchRecipes() throws -> [RecipeDTO] {
        fetchRecipesResult
    }
    
    func fetchRecipe(with id: String) throws -> Recipes.RecipeDetailDTO {
        RecipeDetailDTO(id: "", name: "", imageUrl: "", description: "", ingredients: [])
    }
}

class RecipeRepositoryTests: XCTestCase {
    
    private var repository: RecipeRepository!
    private var dataSource: LocalRecipeDataSourceMock!
    
    override func setUp() async throws {
        try await super.setUp()
        
        dataSource = LocalRecipeDataSourceMock()
        repository = RecipeRepository(dataSource: dataSource)
    }
    
    func test_whenSearchWithQuery_thenResultsAreFiltered() async throws {
        // given
        dataSource.fetchRecipesResult = [
            RecipeDTO(
                id: "1",
                name: "Cake",
                imageUrl: "",
                duration: 0
            ),
            RecipeDTO(
                id: "2",
                name: "Beans",
                imageUrl: "",
                duration: 7
            )
        ]
        let query = "cake"
        // when
        let result = try await repository.search(with: query)
        //then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].name, "Cake")
    }
}
