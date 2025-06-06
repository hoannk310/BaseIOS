//
//  AppDelegate.swift
//  BaseIOS
//
//  Created by nguyen.khai.hoan on 6/2/25.
//

import UIKit
import FirebaseCore
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        checkPermissions { value in
            print(value)
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func checkPermissions(completion: @escaping (Bool) -> Void) {
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let micStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        
        func requestCamera(completion: @escaping (Bool) -> Void) {
            switch cameraStatus {
            case .authorized: completion(true)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video, completionHandler: completion)
            default: completion(false)
            }
        }
        
        func requestMic(completion: @escaping (Bool) -> Void) {
            switch micStatus {
            case .authorized: completion(true)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .audio, completionHandler: completion)
            default: completion(false)
            }
        }
        
        requestCamera { cameraGranted in
            if !cameraGranted {
                completion(false)
                return
            }
            requestMic { micGranted in
                completion(micGranted)
            }
        }
    }
}

