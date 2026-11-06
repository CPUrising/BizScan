import SwiftUI

/// 名片 UI 的深色设计令牌，对应 Figma「名片主页 / 名片详情」。
enum Theme {
    static let page = Color(hex: 0x191919)
    static let pageDetail = Color(hex: 0x171819)
    static let surface = Color(hex: 0x202123)
    static let field = Color(hex: 0x252525)
    static let control = Color(hex: 0x2B2B2B)
    static let dividerStrong = Color(hex: 0x333538)
    static let dividerWeak = Color(hex: 0x2B2B2B)

    static let textPrimary = Color(hex: 0xF1F1F1)
    static let textPrimaryDetail = Color(hex: 0xF5F6F7)
    static let textSecondary = Color(hex: 0xA0A0A0)
    static let textSecondaryDetail = Color(hex: 0xB5B8BD)
    static let textTertiary = Color(hex: 0x777777)
    static let textTertiaryDetail = Color(hex: 0x858A91)

    static let blue = Color(hex: 0x3478F6)
    static let navBlue = Color(hex: 0x176FD1)
    static let green = Color(hex: 0x42AD73)
    static let greenLight = Color(hex: 0x75D49A)
    static let amber = Color(hex: 0xE7AB52)
    static let amberSurface = Color(hex: 0x3B3021)
    static let purple = Color(hex: 0x9A7BDB)
    static let placeholder = Color(hex: 0x626262)

    enum Layout {
        static let screenPadding: CGFloat = 20
        static let headerHeight: CGFloat = 58
        static let searchHeight: CGFloat = 46
        static let groupBarHeight: CGFloat = 62
        static let rowHeight: CGFloat = 108
        static let dateHeaderHeight: CGFloat = 46
    }
}

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}
