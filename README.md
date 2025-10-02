<p align="center">
  <img alt="CometChat" src="https://assets.cometchat.io/website/images/logos/banner.png">
</p>

# CometChatBuilder

`CometChatBuilder` is a lightweight library that allows you to quickly configure and customize your CometChat-powered app by scanning a QR code. The scanned QR code can include theme settings, UI configurations, and other app-level preferences that will automatically be applied to your app.  

---

## ✨ Features
- 📱 **QR Code Scanning**: Easily scan QR codes to fetch app settings.  
- 🎨 **Theme Customization**: Apply custom themes and UI styles instantly.  
- ⚡ **Seamless Integration**: Works directly with your CometChat-powered app.  
- 📦 **Flexible Installation**: Available via CocoaPods and Swift Package Manager (SPM).  

---

## 📦 Installation

### CocoaPods
Add the following to your `Podfile`:
```ruby
pod 'CometChatBuilder'
```
Then run:
```bash
pod install
```

### Swift Package Manager (SPM)
1. In Xcode, go to **File > Add Packages...**  
2. Enter the repository URL:
   ```
   https://github.com/cometchat/chat-builder-ios.git
   ```
3. Select the latest version and add it to your project.

---

## 🚀 Usage

Once installed, import the library into your `ViewController`:

```swift
import UIKit
import CometChatBuilder

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start scanning QR code for app settings
        CometChatBuilder.startScanning(from: self) { style in
            // Apply scanned theme and settings to your app
            self.applyTheme(style)
        }
    }
    
    private func applyTheme(_ style: Any) {
        // Handle and apply the settings to your app here
    }
}
```

---

## 🛠 Requirements
- iOS 13.0+  
- Swift 5.5+  
- Xcode 13+  

---

⚡ With `CometChatBuilder`, you can give users the power to instantly configure your app’s theme and settings just by scanning a QR code.  

## Help and Support
For issues running the project or integrating with our SDK, consult our [documentation](https://www.cometchat.com/docs/sdk/ios/overview) or create a [support ticket](https://help.cometchat.com/hc/en-us) or seek real-time support via the [CometChat Dashboard](https://app.cometchat.com/).


