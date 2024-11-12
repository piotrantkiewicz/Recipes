import UIKit

class HomeViewController: ViewController {
    
    private let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRecipes()
    }
    
    private func loadRecipes() {
        Task {
            await viewModel.loadRecipes()
            // tableView.reloadData()
        }
    }
    
    private func bindViewModel() {
        viewModel.showError = { [weak self] error in
            self?.showErrorAlert(message: error)
        }
    }
}
