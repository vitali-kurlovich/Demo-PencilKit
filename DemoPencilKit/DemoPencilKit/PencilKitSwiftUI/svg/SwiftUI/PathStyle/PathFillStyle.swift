//
//  Created by Kurlovich Vitali on 8/7/26.
//

import struct SwiftUI.Color
import struct SwiftUI.FillStyle
import struct SwiftUI.Gradient

struct PathFillStyle: Sendable, Equatable {
    var color: Color
    var style: FillStyle
}

extension PathFillStyle {
    func mix(with other: Self, by fraction: Double, in colorSpace: Gradient.ColorSpace = .perceptual) -> Self {
        let color = color.mix(with: other.color, by: fraction, in: colorSpace)

        return Self(color: color, style: style)
    }
}
