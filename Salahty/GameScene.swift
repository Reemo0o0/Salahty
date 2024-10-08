//
//  GameScene.swift
//  Salahty
//
//  Created by Reem Alotaibi on 28/03/1446 AH.
// Hello iam Reem here 1 oct
//ALooooooooooo!!shuruq
import SpriteKit

class GameScene: SKScene {
    // تعريف المتغيرات اللازمة لربط العناصر
    var fajrButton: SKSpriteNode!
    var dhuhrButton: SKSpriteNode!
    var asrButton: SKSpriteNode!
    var maghribButton: SKSpriteNode!
    var ishaButton: SKSpriteNode!
    var popUpBackground: SKSpriteNode!
    var yesButton: SKSpriteNode!
    var noButton: SKSpriteNode!
    var dark: SKSpriteNode!
    var catNode: SKSpriteNode!
    var messageLabel: SKLabelNode!
    
    var welcomeLabel: SKLabelNode! // لتعريف رسالة الترحيب
    
    var textField: UITextField! // إضافة UITextField لإدخال النص
    
    
    var currentLevel = 1 // المستوى الحالي، يبدأ من صلاة الفجر
    var finalLevelCompleted = false // متغير لمعرفة ما إذا تم إنهاء جميع الصلوات
    var completedPrayers = Set<String>() // لتخزين الصلوات المكتملة
    
    // متغيرات لتخزين الرسالة والصوت لكل صلاة
    var currentPrayerMessage: String = ""
    var currentPrayerSound: String = ""
    var currentPrayer: String = "" // لتخزين الصلاة الحالية
    
    override func didMove(to view: SKView) {
        // ربط الأزرار المضافة من المحرر بالكود
        fajrButton = childNode(withName: "fajrButton") as? SKSpriteNode
        dhuhrButton = childNode(withName: "dhuhrButton") as? SKSpriteNode
        asrButton = childNode(withName: "asrButton") as? SKSpriteNode
        maghribButton = childNode(withName: "maghribButton") as? SKSpriteNode
        ishaButton = childNode(withName: "ishaButton") as? SKSpriteNode
        
        // إظهار زر الفجر فقط عند بدء اللعبة
        dhuhrButton.isHidden = true
        asrButton.isHidden = true
        maghribButton.isHidden = true
        ishaButton.isHidden = true

        addStaticCatAnimation() // إضافة أنيميشن القطة الافتراضي
        
        textField = UITextField(frame: CGRect(x: 70 , y: 75 , width: 300, height: 50))
        textField.borderStyle = .none // إزالة الإطار
        textField.placeholder = "ادخل هديتك هنا"
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.clear // جعل الخلفية شفافة
        textField.textColor = .white // تغيير لون النص ليتناسب مع التصميم
        textField.returnKeyType = .done

        // إضافة نوع الخط المخصص "bitsy-ar-standardline" والحجم المناسب
        textField.font = UIFont(name: "bitsy-ar-standardline", size: 18) // اختيار الخط "bitsy-ar-standardline" وحجم الخط 18

        
               self.view?.addSubview(textField) // إضافة UITextField إلى المشهد
        
        // عرض رسالة ترحيب وصوت عند بدء التطبيق
         showWelcomeMessage()
     }
     
     // دالة لعرض رسالة ترحيب وصوت
     func showWelcomeMessage() {
         // إضافة الرسالة في وسط الشاشة
         welcomeLabel = SKLabelNode(text: "مرحبا!")
         welcomeLabel.fontSize = 24
         welcomeLabel.fontColor = .white
         welcomeLabel.fontName = "bitsy-ar-standardline"
         welcomeLabel.position = CGPoint(x: 42, y: -350.018) // في وسط الشاشة
         welcomeLabel.zPosition = 100
         addChild(welcomeLabel)
         
         disableButtonsInteraction()

         
         // تأخير لمدة ثانية واحدة قبل تشغيل الصوت الترحيبي
            let wait = SKAction.wait(forDuration: 1.0)
            let playWelcomeSound = SKAction.run { [weak self] in
                self?.playSound(named: "hello") // تأكد من وجود ملف الصوت "welcomeSound"
            }
         // إزالة الرسالة بعد تشغيل الصوت والترحيب (مثلاً بعد 3 ثواني)
           let waitBeforeRemoving = SKAction.wait(forDuration: 21) // تأخير لإعطاء المستخدم وقتًا لرؤية الرسالة
           let removeWelcomeMessage = SKAction.run { [weak self] in
               self?.welcomeLabel.removeFromParent() // إزالة رسالة الترحيب
               self?.enableButtonsInteraction() // إعادة تمكين الأزرار
           }
           
           // تنفيذ الانتظار، تشغيل الصوت، ثم إزالة الرسالة
         run(SKAction.sequence([wait, playWelcomeSound, waitBeforeRemoving, removeWelcomeMessage]))

     }

    // دالة لإضافة أنيميشن افتراضي للقطة
    func addStaticCatAnimation() {
        if catNode == nil {
            catNode = SKSpriteNode(imageNamed: "StaticCat1")
            catNode.position = CGPoint(x: -111.282, y: -330.055)
            catNode.size = CGSize(width: 53.056, height: 63.466)
            catNode.zPosition = 3
            addChild(catNode)
        }

        // تشغيل أنيميشن ثابت افتراضي
        let catTexture1 = SKTexture(imageNamed: "StaticCat1")
        let catTexture2 = SKTexture(imageNamed: "StaticCat2")
        let staticAnimation = SKAction.animate(with: [catTexture1, catTexture2], timePerFrame: 0.5)
        let repeatStaticAnimation = SKAction.repeatForever(staticAnimation)
        catNode.run(repeatStaticAnimation, withKey: "staticAnimation")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            // التأكد من أن الزر ليس معطلًا (بسبب الترحيب)
                 if touchedNode.name == "disabled" {
                     return // تجاهل الضغط إذا كان الزر معطلًا
                 }
            
            // التحقق من الصلاة التي تم الضغط عليها وتحديد الرسالة والصوت
            if touchedNode == fajrButton {
                currentPrayerMessage = "هل صليت صلاة الفجر؟"
                currentPrayerSound = "fajrSound"
                currentPrayer = "fajr"
            } else if touchedNode == dhuhrButton {
                currentPrayerMessage = "هل صليت صلاة الظهر؟"
                currentPrayerSound = "dhuhrSound"
                currentPrayer = "dhuhr"
            } else if touchedNode == asrButton {
                currentPrayerMessage = "هل صليت صلاة العصر؟"
                currentPrayerSound = "asrSound"
                currentPrayer = "asr"
            } else if touchedNode == maghribButton {
                currentPrayerMessage = "هل صليت صلاة المغرب؟"
                currentPrayerSound = "maghribSound"
                currentPrayer = "maghrib"
            } else if touchedNode == ishaButton {
                currentPrayerMessage = "هل صليت صلاة العشاء؟"
                currentPrayerSound = "ishaSound"
                currentPrayer = "isha"
            }
            
            // إذا تم الضغط على أي زر صلاة ولم تكتمل الصلاة سابقًا
            if (touchedNode == fajrButton || touchedNode == dhuhrButton || touchedNode == asrButton || touchedNode == maghribButton || touchedNode == ishaButton) && !completedPrayers.contains(currentPrayer) {
                showPopUp(prayerMessage: currentPrayerMessage)
                playSound(named: currentPrayerSound)
            }

            // التعامل مع الضغط على زر "نعم"
            else if touchedNode == yesButton {
                hidePopUp()
                displayMessage("أحسنت!", position: CGPoint(x: 42, y: -350.018))

                // إضافة الصلاة المكتملة
                completedPrayers.insert(currentPrayer)

                // إذا كانت صلاة العشاء، أظهر صوت خاص
                if currentPrayer == "isha" {
                    playSound(named: "YouAreSpecial")
                } else {
                    playSound(named: "welldone")
                }

                animateYesCat(W: 53.056, H: 63.466, X: -117.282, Y: -328.055)
                showNextPrayer() // الانتقال إلى الصلاة التالية
            }

            // التعامل مع الضغط على زر "لا"
            else if touchedNode == noButton {
                hidePopUp()
                displayMessage("اذهب للصلاة", position: CGPoint(x: 42, y: -350.018))
                playSound(named: "BABY")
                animateNoCat(W: 53.056, H: 63.466, X: -117.282, Y: -328.055)

                // ملاحظة: لا يتم تغيير الليفل هنا، يبقى في نفس الصلاة
            }
        }
        
        // إخفاء UITextField عند الضغط على الشاشة
                   self.view?.endEditing(true) // إخفاء لوحة المفاتيح
    }
    // دالة لإزالة UITextField عند الانتقال من المشهد
     override func willMove(from view: SKView) {
         textField.removeFromSuperview()
     }
     
    // دالة لإظهار المستوى (الصلاة) التالية
    func showNextPrayer() {
        if currentPrayer == "fajr" {
            dhuhrButton.isHidden = false
        } else if currentPrayer == "dhuhr" {
            asrButton.isHidden = false
        } else if currentPrayer == "asr" {
            maghribButton.isHidden = false
        } else if currentPrayer == "maghrib" {
            ishaButton.isHidden = false
        } else if currentPrayer == "isha" {
            finalLevelCompleted = true
            displayMessage("انت مميز!!", position: CGPoint(x: 42, y: -350.018))
            playSound(named: "allPrayersCompletedSound")
        }
    }
    
    // دالة لإظهار نافذة البوب أب مع رسالة مخصصة
    func showPopUp(prayerMessage: String) {
        // إنشاء خلفية دارك بحجم وموقع محددين
        dark = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.4), size: CGSize(width: size.width, height: size.height))
        dark.position = CGPoint(x: 0.416, y: -0.12)
        dark.name = "dark"
        dark.zPosition = 5
        addChild(dark)
        
        // إنشاء خلفية البوب أب بحجم وموقع محددين
        let popUpSize = CGSize(width: 303, height: 302)
        popUpBackground = SKSpriteNode(imageNamed: "popUpBackgroundImage 1")
        popUpBackground.size = popUpSize
        popUpBackground.position = CGPoint(x: 0.5, y: 0.5)
        popUpBackground.name = "popUpBackground"
        popUpBackground.zPosition = 10
        addChild(popUpBackground)
        
        // إنشاء زر "نعم" بحجم وموقع محددين داخل خلفية البوب أب
        let yesButtonSize = CGSize(width: 119.345, height: 123.876)
        yesButton = SKSpriteNode(imageNamed: "yesButtonImage")
        yesButton.size = yesButtonSize
        yesButton.position = CGPoint(x: 80.685, y: -79.998)
        yesButton.name = "yesButton"
        yesButton.zPosition = 11
        addChild(yesButton)
        
        // إنشاء زر "لا" بحجم وموقع محددين داخل خلفية البوب أب
        let noButtonSize = CGSize(width: 119.345, height: 123.876)
        noButton = SKSpriteNode(imageNamed: "noButtonImage")
        noButton.size = noButtonSize
        noButton.position = CGPoint(x: -77.068, y: -80)
        noButton.name = "noButton"
        noButton.zPosition = 11
        addChild(noButton)
        
        // عرض الرسالة المخصصة داخل نافذة البوب أب
        messageLabel?.removeFromParent()
        messageLabel = SKLabelNode(text: prayerMessage)
        messageLabel.fontName = "bitsy-ar-standardline" // تعيين الخط المخصص
        messageLabel.fontSize = 16
        messageLabel.fontColor = .white
        messageLabel.position = CGPoint(x: -3, y: -8)
        messageLabel.zPosition = 11
        popUpBackground.addChild(messageLabel)
    }
    
    // دالة لإخفاء نافذة البوب أب
    func hidePopUp() {
        dark?.removeFromParent()
        popUpBackground?.removeFromParent()
        yesButton?.removeFromParent()
        noButton?.removeFromParent()
    }
    
    // دالة لعرض رسالة في مكان معين بعد إغلاق البوب أب
    func displayMessage(_ message: String, position: CGPoint) {
        messageLabel?.removeFromParent()
        messageLabel = SKLabelNode(text: message)
        messageLabel.fontName = "bitsy-ar-standardline" // تعيين الخط المخصص
        messageLabel.fontSize = 24
        messageLabel.fontColor = .white
        messageLabel.position = position
        messageLabel.zPosition = 20
        addChild(messageLabel)
    }
    
    // دالة لتشغيل الصوت
    func playSound(named soundName: String) {
        let playSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: false)
        run(playSound)
    }
    
    // دالة لتشغيل الأنيميشن الخاص بزر "نعم"
    func animateYesCat(W: CGFloat, H: CGFloat, X: CGFloat, Y: CGFloat) {
        catNode?.removeAction(forKey: "staticAnimation")
        
        let catTexture1 = SKTexture(imageNamed: "HappyAnimation1")
        let catTexture2 = SKTexture(imageNamed: "HappyAnimation2")
        let animation = SKAction.animate(with: [catTexture1, catTexture2], timePerFrame: 0.5)
        let repeatAnimation = SKAction.repeat(animation, count: 3)
        
        catNode?.position = CGPoint(x: -111.282, y: -330.055)
        catNode?.size = CGSize(width: W, height: H)
        
        catNode?.run(repeatAnimation) {
            self.addStaticCatAnimation()
        }
    }
    
    // دالة لتشغيل الأنيميشن الخاص بزر "لا"
    func animateNoCat(W: CGFloat, H: CGFloat, X: CGFloat, Y: CGFloat) {
        catNode?.removeAction(forKey: "staticAnimation")
        
        let catTexture1 = SKTexture(imageNamed: "AngryAnimation1")
        let catTexture2 = SKTexture(imageNamed: "AngryAnimation2")
        let animation = SKAction.animate(with: [catTexture1, catTexture2], timePerFrame: 0.5)
        let repeatAnimation = SKAction.repeat(animation, count: 3)
        
        catNode?.position = CGPoint(x: -111.282, y: -330.055)
        catNode?.size = CGSize(width: W, height: H)
        
        catNode?.run(repeatAnimation) {
            self.addStaticCatAnimation()
        }
    }
    
    // دالة لتعطيل تفاعل الأزرار
    func disableButtonsInteraction() {
        fajrButton.name = "disabled"
        dhuhrButton.name = "disabled"
        asrButton.name = "disabled"
        maghribButton.name = "disabled"
        ishaButton.name = "disabled"
    }

    // دالة لإعادة تمكين تفاعل الأزرار
    func enableButtonsInteraction() {
        fajrButton.name = "fajrButton"
        dhuhrButton.name = "dhuhrButton"
        asrButton.name = "asrButton"
        maghribButton.name = "maghribButton"
        ishaButton.name = "ishaButton"
    }
}
