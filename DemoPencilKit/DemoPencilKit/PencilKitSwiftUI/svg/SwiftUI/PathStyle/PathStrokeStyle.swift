//
//  Created by Kurlovich Vitali on 8/7/26.
//

import struct SwiftUI.Color
import struct SwiftUI.Gradient
import struct SwiftUI.StrokeStyle

struct PathStrokeStyle: Sendable, Equatable {
    var color: Color
    var style: StrokeStyle
}

extension PathStrokeStyle {
    func mix(with other: Self, by fraction: Double, in colorSpace: Gradient.ColorSpace = .perceptual) -> Self {
        let color = color.mix(with: other.color, by: fraction, in: colorSpace)
        let style = style.mix(with: other.style, by: fraction)

        return Self(color: color, style: style)
    }
}
