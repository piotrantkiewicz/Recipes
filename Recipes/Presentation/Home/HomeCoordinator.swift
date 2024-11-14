import UIKit

class HomeCoordinator: Coordinator {
    
    private let container: DependencyContainer
    var navigationController: UINavigationController
    
    init(container: DependencyContainer, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = HomeViewModel(repository: container.recipeRepository)
        let viewController = HomeViewController(viewModel: viewModel)
        viewController.coordinator = self
        viewModel.didSelectRecipe = { [weak self] recipe in
            self?.showDetail(for: recipe)
        }
        
        navigationController.pushViewController(viewController, animated: false)
    }
    
    private func showDetail(for: Recipe) {
        let coordinator = RecipeDetailCoordinator(container: container, navigationController: navigationController)
        coordinator.start()
    }
}
