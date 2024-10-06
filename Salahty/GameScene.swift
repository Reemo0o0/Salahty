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
        
        // إضافة الأنيميشن الافتراضي للقطة
        addStaticCatAnimation()
    }
    
    // دالة لإضافة أنيميشن افتراضي للقطة
    func addStaticCatAnimation() {
        if catNode == nil {
            catNode = SKSpriteNode(imageNamed: "StaticCat1")
            catNode.position = CGPoint(x: -117.282, y: -328.055) // استخدام الموقع الذي ذكرته
            catNode.size = CGSize(width: 53.056, height: 63.466) // استخدام الحجم الذي ذكرته
            catNode.zPosition = 20
            addChild(catNode)
        }

        // تشغيل أنيميشن ثابت افتراضي (الصورة الثابتة هي أنيميشن)
        let catTexture1 = SKTexture(imageNamed: "StaticCat1")
        let catTexture2 = SKTexture(imageNamed: "StaticCat2")
        let staticAnimation = SKAction.animate(with: [catTexture1, catTexture2], timePerFrame: 0.5)
        let repeatStaticAnimation = SKAction.repeatForever(staticAnimation)

        // تشغيل الأنيميشن بشكل مستمر
        catNode.run(repeatStaticAnimation, withKey: "staticAnimation")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
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
            
            // إذا تم الضغط على أي من أزرار الصلاة، أظهر نافذة البوب أب
            if touchedNode == fajrButton || touchedNode == dhuhrButton || touchedNode == asrButton || touchedNode == maghribButton || touchedNode == ishaButton {
                showPopUp(prayerMessage: currentPrayerMessage)
                
                // تشغيل الصوت المحدد للصلاة
                playSound(named: currentPrayerSound)
            }
            else if touchedNode == yesButton {
                // عند الضغط على "نعم"
                hidePopUp()
                displayMessage("أحسنت! بارك الله فيك.", position: CGPoint(x: 42, y: -350.018)) // تحديد مكان النص
                
                // تشغيل الصوت بناءً على الصلاة
                if currentPrayer == "isha" {
                    playSound(named: "YouAreSpecial") // صوت خاص لصلاة العشاء
                } else {
                    playSound(named: "welldone") // الصوت العام لباقي الصلوات
                }
                
                animateYesCat(W: 53.056, H: 63.466, X: -117.282, Y: -328.055) // تشغيل أنيميشن زر "نعم"
            }
            else if touchedNode == noButton {
                // عند الضغط على "لا"
                hidePopUp()
                displayMessage("اذهب للصلاة، نحن بانتظارك.", position: CGPoint(x: 42, y: -350.018)) // تحديد مكان النص
                playSound(named: "BABY")
                animateNoCat(W: 53.056, H: 63.466, X: -117.282, Y: -328.055) // تشغيل أنيميشن زر "لا"
            }
        }
    }
    
    // دالة لإظهار نافذة البوب أب مع رسالة مخصصة
    func showPopUp(prayerMessage: String) {
        // إنشاء خلفية دارك بحجم وموقع محددين
        dark = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.4), size: CGSize(width: size.width, height: size.height)) // تحديد لون وخلفية مظلمة شفافة
        dark.position = CGPoint(x: 0.416, y: -0.12)
        dark.name = "dark"
        dark.zPosition = 5
        addChild(dark)
        
        // إنشاء خلفية البوب أب بحجم وموقع محددين
        let popUpSize = CGSize(width: 303, height: 302) // حدد الحجم المناسب للخلفية
        popUpBackground = SKSpriteNode(imageNamed: "popUpBackgroundImage")
        popUpBackground.size = popUpSize
        popUpBackground.position = CGPoint(x: 0.5, y: 0.5) // حدد الموقع المناسب للخلفية
        popUpBackground.name = "popUpBackground"
        popUpBackground.zPosition = 10
        addChild(popUpBackground)
        
        // إنشاء زر "نعم" بحجم وموقع محددين داخل خلفية البوب أب
        let yesButtonSize = CGSize(width: 119.345, height: 123.876) // حدد الحجم المناسب لزر "نعم"
        yesButton = SKSpriteNode(imageNamed: "yesButtonImage")
        yesButton.size = yesButtonSize
        yesButton.position = CGPoint(x: 80.685, y: -79.998) // حدد الموقع المناسب لزر "نعم" بالنسبة للخلفية
        yesButton.name = "yesButton"
        yesButton.zPosition = 11
        addChild(yesButton)
        
        // إنشاء زر "لا" بحجم وموقع محددين داخل خلفية البوب أب
        let noButtonSize = CGSize(width: 119.345, height: 123.876) // حدد الحجم المناسب لزر "لا"
        noButton = SKSpriteNode(imageNamed: "noButtonImage")
        noButton.size = noButtonSize
        noButton.position = CGPoint(x: -77.068, y: -80) // حدد الموقع المناسب لزر "لا" بالنسبة للخلفية
        noButton.name = "noButton"
        noButton.zPosition = 11
        addChild(noButton)
        
        // عرض الرسالة المخصصة داخل نافذة البوب أب
        messageLabel?.removeFromParent() // إزالة الرسالة السابقة إذا وجدت
        
        messageLabel = SKLabelNode(text: prayerMessage)
        messageLabel.fontSize = 24
        messageLabel.fontColor = .white
        messageLabel.position = CGPoint(x: -16, y: -10) // موقع النص داخل البوب أب
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
        messageLabel?.removeFromParent() // إزالة الرسالة السابقة إذا وجدت
        
        messageLabel = SKLabelNode(text: message)
        messageLabel.fontSize = 20
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
    
    // دالة لتشغيل الأنيميشن الخاص بزر "نعم" مع تحديد العرض (W)، الارتفاع (H)، والموقع (X, Y)
    func animateYesCat(W: CGFloat, H: CGFloat, X: CGFloat, Y: CGFloat) {
        // إيقاف الأنيميشن الافتراضي أولاً
        catNode?.removeAction(forKey: "staticAnimation")
        
        let catTexture1 = SKTexture(imageNamed: "HappyAnimation1")
        let catTexture2 = SKTexture(imageNamed: "HappyAnimation2")
        let animation = SKAction.animate(with: [catTexture1, catTexture2], timePerFrame: 0.5)
        let repeatAnimation = SKAction.repeat(animation, count: 3)
        
        catNode?.position = CGPoint(x: X, y: Y) // تعيين موقع الأنيميشن
        catNode?.size = CGSize(width: W, height: H) // تعيين العرض والارتفاع
        
        catNode?.run(repeatAnimation) {
            // بعد انتهاء الأنيميشن، إعادة تشغيل الأنيميشن الافتراضي
            self.addStaticCatAnimation()
        }
    }
    
    // دالة لتشغيل الأنيميشن الخاص بزر "لا" مع تحديد العرض (W)، الارتفاع (H)، والموقع (X, Y)
    func animateNoCat(W: CGFloat, H: CGFloat, X: CGFloat, Y: CGFloat) {
        // إيقاف الأنيميشن الافتراضي أولاً
        catNode?.removeAction(forKey: "staticAnimation")
        
        let catTexture1 = SKTexture(imageNamed: "AngryAnimation1")
        let catTexture2 = SKTexture(imageNamed: "AngryAnimation2")
        let animation = SKAction.animate(with: [catTexture1, catTexture2], timePerFrame: 0.5)
        let repeatAnimation = SKAction.repeat(animation, count: 3)
        
        catNode?.position = CGPoint(x: X, y: Y) // تعيين موقع الأنيميشن
        catNode?.size = CGSize(width: W, height: H) // تعيين العرض والارتفاع
        
        catNode?.run(repeatAnimation) {
            // بعد انتهاء الأنيميشن، إعادة تشغيل الأنيميشن الافتراضي
            self.addStaticCatAnimation()
        }
    }
}
