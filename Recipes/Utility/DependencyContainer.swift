import Foundation

class DependencyContainer {
    
    lazy var recipeDataSource: LocalRecipeDataSourceProtocol = {
        LocalRecipeDataSource()
    }()
    
    lazy var recipeRepository: RecipeRepository = {
        return RecipeRepository(dataSource: recipeDataSource)
    }()
}
