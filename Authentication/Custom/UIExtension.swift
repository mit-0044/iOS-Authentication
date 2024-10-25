//
//  UIExtension.swift
//  Authentication
//
//  Created by Mit Patel on 01/09/24.
//

import SwiftUI
import Combine

enum SFCompactRounded: String {
    case regular = "SFCompactRounded-Regular"
    case medium = "SFCompactRounded-Medium"
    case semibold = "SFCompactRounded-SemiBold"
    case bold = "SFCompactRounded-Bold"
    case heavy = "SFCompactRounded-Heavy"
    case arial = "ArialRoundedMTBold"
}

extension Font {
    static func customfont(_ font: SFCompactRounded, fontSize: CGFloat) -> Font {
        custom(font.rawValue, size: fontSize)
    }
    
    static func customfont(_ font: SFCompactRounded, fontSize: CGFloat, weight: Font.Weight) -> Font {
        custom(font.rawValue, size: fontSize)
    }
}

class Utilities {
    static let AppName = "Authentication"
    
    class func UDSET(data: Any, key: String) {
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func UDValue(key: String) -> Any {
        return UserDefaults.standard.value(forKey: key) as Any
    }
    
    class func UDString(key: String) -> String {
        return (UserDefaults.standard.string(forKey: key) ?? "") as String
    }
    
    class func UDValueBool( key: String) -> Bool {
        return UserDefaults.standard.value(forKey: key) as? Bool ?? false
    }
    
    class func UDValueTrueBool( key: String) -> Bool {
        return UserDefaults.standard.value(forKey: key) as? Bool ?? true
    }
    
    class func UDRemove( key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private static let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    private static let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
    private static let contactRegEx = "^[+]?(?:[0-9]{2})?[0-9]{10}$"

    private static let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    private static let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
    private static let contactPredicate = NSPredicate(format: "SELF MATCHES %@", contactRegEx)

    // Email validation
    class func isValidEmail(_ email: String) -> Bool {
        return emailPredicate.evaluate(with: email)
    }

    // Password validation (at least 8 characters, 1 letter, 1 number, 1 special character)
    class func isValidPassword(_ password: String) -> Bool {
        return passwordPredicate.evaluate(with: password)
    }

    // Contact validation (optional country code + 10 digits)
    class func isValidContact(_ contact: String) -> Bool {
        return contactPredicate.evaluate(with: contact)
    }
}

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(limit))
            }
        }
        return self
    }
}

extension CGFloat {
    
    static var screenWidth: Double {
        return UIScreen.main.bounds.size.width
    }
    
    static var screenHeight: Double {
        return UIScreen.main.bounds.size.height
    }
    
    static func widthPer(per: Double) -> Double {
        return screenWidth * per
    }
    
    static func heightPer(per: Double) -> Double {
        return screenHeight * per
    }
    
    static var topInsets: Double {
        if let keyWindow = UIApplication.shared.keyWindow {
            return keyWindow.safeAreaInsets.top
        }
        return 0.0
    }
    
    static var bottomInsets: Double {
        if let keyWindow = UIApplication.shared.keyWindow {
            return keyWindow.safeAreaInsets.bottom
        }
        return 0.0
    }
    
    static var horizontalInsets: Double {
        if let keyWindow = UIApplication.shared.keyWindow {
            return keyWindow.safeAreaInsets.left + keyWindow.safeAreaInsets.right
        }
        return 0.0
    }
    
    static var verticalInsets: Double {
        if let keyWindow = UIApplication.shared.keyWindow {
            return keyWindow.safeAreaInsets.top + keyWindow.safeAreaInsets.bottom
        }
        return 0.0
    }
    
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 3: // RGB(12 -bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct ShowButton: ViewModifier {
    @Binding var isShow: Bool
    
    public func body(content: Content) -> some View {
        
        HStack {
            content
            Button {
                isShow.toggle()
            } label: {
                Image(systemName: !isShow ? "eye.fill" : "eye.slash.fill" )
                    .foregroundColor(.gray)
            }

        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corner:  UIRectCorner) -> some View {
        clipShape(CustomCorners(radius: radius, corners: corner))
    }
}

struct CustomCorners: Shape {
    var radius: CGFloat = 12.5
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
