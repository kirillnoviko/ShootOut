import UIKit

class ThemeManager {
    static let shared = ThemeManager() // Синглтон

    enum Theme: String {
        case light
        case dark
    }

    private(set) var currentTheme: Theme = .light {
        didSet {
            saveTheme()
        }
    }

    private init() {
        loadTheme()
    }

    // MARK: - Цветовые схемы
    var backgroundColor: UIColor {
        currentTheme == .light ? UIColor.hex(0xFFFFFF) : UIColor.hex(0x020637)
    }

    var textColor: UIColor {
        currentTheme == .light ? UIColor.hex(0x020637) : UIColor.hex(0xFFFFFF)
    }

    
    
    // SETTINGS
    var buttonBackgroundColorSettins: UIColor {
        currentTheme == .light ? UIColor.hex(0x397EB4) : UIColor.hex(0xF6F6FC)
    }
    var buttonTextColorSettins: UIColor {
        currentTheme == .light ? UIColor.hex(0xF6F6FC) : UIColor.hex(0x397EB4)
    }

    
    
    var separatorColor: UIColor {
        currentTheme == .light ? UIColor.hex(0xCCCCCC) : UIColor.hex(0xFFFFFF)
    }

    func setTheme(_ theme: Theme) {
        currentTheme = theme
        NotificationCenter.default.post(name: .themeChanged, object: nil)
    }

    // MARK: - Сохранение и загрузка темы
    private func saveTheme() {
        UserDefaults.standard.set(currentTheme.rawValue, forKey: "selectedTheme")
    }

    private func loadTheme() {
        if let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme"),
           let theme = Theme(rawValue: savedTheme) {
            currentTheme = theme
        } else {
            currentTheme = .light
        }
    }
}

extension Notification.Name {
    static let themeChanged = Notification.Name("themeChanged")
}



