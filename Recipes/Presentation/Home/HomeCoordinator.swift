import UIKit

class HomeCoordinator: Coordinator {
    
    private let container: DependencyContainer
    var navigationController: UINavigationController
    
    init(container: DependencyContainer, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }
    
    func start() {
        let ViewModel = HomeViewModel(repository: container.recipeRepository)
        let viewController = HomeViewController(viewModel: ViewModel)
        
        navigationController.pushViewController(viewController, animated: false)
    }
}
