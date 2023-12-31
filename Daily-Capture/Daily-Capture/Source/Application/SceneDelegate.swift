//  Daily-Capture - SceneDelegate.swift
//  Created by zhilly, vetto on 2023/06/29

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene: UIWindowScene = (scene as? UIWindowScene) else { return }
        let mainViewModel: MainViewModel = .init()
        let mainViewController: MainViewController = .init(viewModel: mainViewModel)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: mainViewController)
        window?.makeKeyAndVisible()
    }
}
