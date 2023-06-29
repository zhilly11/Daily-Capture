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
        let mainViewController: MainViewController = .init()
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
    }
}
