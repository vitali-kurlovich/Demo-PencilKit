//
//  Created by Kurlovich Vitali on 8/7/26.
//

import struct SwiftUI.Gradient

struct PathStyle: Sendable, Equatable {
    var fill: PathFillStyle
    var stroke: PathStrokeStyle
}

extension PathStyle {
    func mix(with other: Self, by fraction: Double, in colorSpace: Gradient.ColorSpace = .perceptual) -> Self {
        let fill = fill.mix(with: other.fill, by: fraction, in: colorSpace)
        let stroke = stroke.mix(with: other.stroke, by: fraction, in: colorSpace)

        return Self(fill: fill, stroke: stroke)
    }
}
