//
//  AppDelegate.swift
//  PushTutorial
//
//  Created by 남유성 on 5/1/24.
//

import UIKit
import Firebase
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    
    // MARK: - 앱을 실행할 준비가 완료되었을 때 실행되는 메서드
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        // MARK: - APNs의 원격 알림에 앱을 등록
        application.registerForRemoteNotifications()
        
        
        // FCM SDK를 사용하기 위해 configure 메서드를 호출해줍니다.
        FirebaseApp.configure()
        // AppDelegate를 Messaging.messaging()의 delegate로 설정합니다.
        Messaging.messaging().delegate = self
        
        return true
    }
    
    // MARK: - APNs에 앱이 성공적으로 등록되었을 때 실행되는 메서드
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // MARK: - APNs의 토큰을 FCM 등록 토큰에 매핑
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // MARK: - APNs에 앱이 등록 실패했을 때 실행되는 메서드
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: any Error
    ) {
        print(error)
    }
}


// MARK: - MessagingDelegate의 메서드를 통해 FCM SDK에서 생성한 등록 토큰을 수신하고 처리하는 작업을 수행할 수 있습니다.
extension AppDelegate: MessagingDelegate {
    
    // MARK: - FCM SDK로부터 FCM 등록 토큰을 받았을 때 실행되는 메서드
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        print("Firebase registration token: \(String(describing: fcmToken))")
    }
}

// MARK: - UNUserNotificationCenterDelegate의 메서드를 통해 전달받은 알림을 표시할 수 있습니다.
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // MARK: - 앱이 Foreground에서 Running 중인 상황에서 알림이 왔을 때 실행되는 메서드
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions
    ) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print("UserInfo: ", userInfo)
        
        completionHandler([.banner, .sound, .badge])
    }
    
    // MARK: - 앱에 알림이 왔을 때 실행되는 메서드 (Foreground/Background 모두)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        
        let userInfo = response.notification.request.content.userInfo
        print("didReceive: userInfo: ", userInfo)
        
        // MARK: - 여기서 알림 배너에서 사용자의 응답을 처리하는 로직을 구현합니다.
        
        completionHandler()
    }
}
