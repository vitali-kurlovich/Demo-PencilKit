//
//  Created by Kurlovich Vitali on 8/7/26.
//

import struct CoreGraphics.CGAffineTransform
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

extension PathStyle {
    func unscaleIfNeeds(_ tr: CGAffineTransform) -> PathStyle {
        let stroke = stroke.unscaleIfNeeds(tr)
        return PathStyle(fill: fill, stroke: stroke)
    }
}

extension FillShading {
    init(_ style: PathFillStyle) {
        self.init(color: style.color, style: style.style)
    }
}

extension StrokeShading {
    init(_ style: PathStrokeStyle) {
        self.init(color: style.color, style: style.style)
    }
}

extension ShadingStyle {
    init(_ style: PathStyle) {
        let fill: FillShading? = if style.fill.color == .clear {
            nil
        } else {
            FillShading(style.fill)
        }

        let stroke: StrokeShading? = if style.stroke.color == .clear || style.stroke.style.lineWidth == 0 {
            nil
        } else {
            StrokeShading(style.stroke)
        }

        self.init(fill: fill, stroke: stroke)
    }
}
