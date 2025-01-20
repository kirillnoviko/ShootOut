//
//  SceneDelegate.swift
//  ShootOut
//
//  Created by User on 16.01.25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

      func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
          guard let windowScene = (scene as? UIWindowScene) else { return }

          let window = UIWindow(windowScene: windowScene)
          self.window = window

          let storyboard = UIStoryboard(name: "SOTLoaderScreenView", bundle: nil)
          let loaderVC = storyboard.instantiateViewController(withIdentifier: "ShootOutLoaderViewController") as! ShootOutLoaderViewController
          let navigationController = UINavigationController(rootViewController: loaderVC)
          
          window.rootViewController = navigationController
          window.makeKeyAndVisible()
      }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("SceneDelegate: sceneDidDisconnect")
        // Освобождение ресурсов, если это необходимо
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("SceneDelegate: sceneDidBecomeActive")
        // Перезапустите приостановленные задачи
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("SceneDelegate: sceneWillResignActive")
        // Приостановите задачи, которые не должны выполняться в неактивном состоянии
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("SceneDelegate: sceneWillEnterForeground")
        // Восстановите состояние интерфейса, если это нужно
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("SceneDelegate: sceneDidEnterBackground")
        // Сохраните данные и состояние приложения перед переходом в фоновый режим
        saveAppState()
    }

    private func saveAppState() {
        // Пример функции сохранения данных
        print("Saving application state...")
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.saveContext()
    }
}
