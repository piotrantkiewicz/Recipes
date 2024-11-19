import UIKit

class AppCoordiantor {
    
    private let window: UIWindow
    private let container: DependencyContainer
    
    init(window: UIWindow, container: DependencyContainer) {
        self.window = window
        self.container = container
    }
    
    func start() {
        let tabBarController = UITabBarController()
        
        tabBarController.viewControllers = [
            setupHome(),
            setupDiscovery(),
            setupBookmarks(),
            setupProfile()
        ]

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func setupHome() -> UIViewController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = UITabBarItem(
            title: "tabBar.home".localized,
            image: UIImage(named: "home"),
            tag: 0
        )
        
        let homeCoordinator = HomeCoordinator(
            container: container,
            navigationController: navigationController
        )
        homeCoordinator.start()
        
        return navigationController
    }
    
    private func setupDiscovery() -> UIViewController {
        let discoveryVC = UIViewController()
        discoveryVC.tabBarItem = UITabBarItem(
            title: "tabBar.discovery".localized,
            image: UIImage(named: "discovery"),
            tag: 1
        )
        return discoveryVC
    }
    
    private func setupBookmarks() -> UIViewController {
        
        let naviagationController = UINavigationController()
        naviagationController.tabBarItem = UITabBarItem(
            title: "tabBar.bookmarks".localized,
            image: UIImage(named: "bookmark"),
            tag: 2
        )
        
        let coordinator = BookmarksCoordinator(
            navigationController: naviagationController,
            container: container
        )
        coordinator.start()
        
        return naviagationController
    }
    
    private func setupProfile() -> UIViewController {
        let profileVC = UIViewController()
        profileVC.tabBarItem = UITabBarItem(
            title: "tabBar.profile".localized,
            image: UIImage(named: "profile"),
            tag: 3
        )
        return profileVC
    }
}
