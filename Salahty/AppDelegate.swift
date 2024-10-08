//
//  AppDelegate.swift
//  Salahty
//
//  Created by Reem Alotaibi on 28/03/1446 AH.
//

import UIKit
import AVFoundation // استيراد المكتبة

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var audioPlayer: AVAudioPlayer? // متغير مشغل الصوت

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // تشغيل الصوت عند فتح التطبيق
        playSound()
        return true
    }

    func playSound() {
        // تحديد مكان ملف الصوت
        if let soundURL = Bundle.main.url(forResource: "BackgrpundOst", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.volume = 0.3 // ضبط مستوى الصوت (0.5 يعني نصف الصوت)
                audioPlayer?.play() // تشغيل الصوت
            } catch {
                print("حدث خطأ في تشغيل الصوت")
            }
        } else {
            print("لم يتم العثور على ملف الصوت")
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // يتم تنفيذها عند انتقال التطبيق إلى الخلفية.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // يتم تنفيذها عند دخول التطبيق للخلفية.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // يتم تنفيذها عند عودة التطبيق إلى الواجهة.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // يتم تنفيذها عند إعادة تفعيل التطبيق.
    }
}
