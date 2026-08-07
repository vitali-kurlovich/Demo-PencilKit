//
//  Created by Kurlovich Vitali on 8/7/26.
//

import struct CoreGraphics.CGAffineTransform
import struct CoreGraphics.CGFloat
import struct SwiftUI.Color
import struct SwiftUI.Gradient
import struct SwiftUI.StrokeStyle

extension PathStrokeStyle {
    enum StrokeWidthMode: Sendable, Equatable {
        case absolute
        case relative
    }
}

struct PathStrokeStyle: Sendable, Equatable {
    var color: Color
    var style: StrokeStyle

    var widthMode: StrokeWidthMode

    init(
        color: Color,
        style: StrokeStyle = .init(lineWidth: 1),
        widthMode: StrokeWidthMode = .relative,
    ) {
        self.color = color
        self.style = style
        self.widthMode = widthMode
    }
}

extension PathStrokeStyle {
    func mix(with other: Self, by fraction: Double, in colorSpace: Gradient.ColorSpace = .perceptual) -> Self {
        let color = color.mix(with: other.color, by: fraction, in: colorSpace)
        let style = style.mix(with: other.style, by: fraction)

        return Self(color: color, style: style, widthMode: widthMode)
    }
}

extension PathStrokeStyle {
    func unscaleIfNeeds(_ tr: CGAffineTransform) -> PathStrokeStyle {
        switch widthMode {
        case .absolute:
            PathStrokeStyle(color: color, style: style.unscale(tr))
        case .relative:
            self
        }
    }
}

// CGAffineTransform

extension StrokeStyle {
    func scaled(_ scaleFactor: CGFloat) -> StrokeStyle {
        if scaleFactor == 1 {
            return self
        }

        let lineWidth: CGFloat = lineWidth * scaleFactor
        let miterLimit: CGFloat = miterLimit * scaleFactor

        let dash: [CGFloat] = dash.map { $0 * scaleFactor }
        let dashPhase: CGFloat = dashPhase * scaleFactor

        return StrokeStyle(lineWidth: lineWidth, lineCap: lineCap, lineJoin: lineJoin, miterLimit: miterLimit, dash: dash, dashPhase: dashPhase)
    }

    func unscale(_ tr: CGAffineTransform) -> StrokeStyle {
        if tr.isIdentity {
            return self
        }

        if tr.a == 1, tr.b == 0, tr.c == 0, tr.d == 1 {
            return self
        }

        let scale = tr.decomposed().scale

        let inverseScale = 2 / (scale.width + scale.height)

        return scaled(inverseScale)
    }
}
