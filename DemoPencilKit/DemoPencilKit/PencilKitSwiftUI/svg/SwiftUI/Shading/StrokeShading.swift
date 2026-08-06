//
//  Created by Kurlovich Vitali on 8/6/26.
//

import struct CoreGraphics.CGFloat
import struct SwiftUI.Color
import struct SwiftUI.GraphicsContext
import struct SwiftUI.StrokeStyle

public struct StrokeShading: Sendable {
    public var shading: GraphicsContext.Shading
    public var style: StrokeStyle

    public init(
        shading: GraphicsContext.Shading,
        style: StrokeStyle = StrokeStyle(lineWidth: 1),
    ) {
        self.shading = shading
        self.style = style
    }
}

public extension StrokeShading {
    init(
        shading: GraphicsContext.Shading,
        lineWidth: CGFloat,
    ) {
        self.init(shading: shading,
                  style: StrokeStyle(lineWidth: lineWidth))
    }

    init(
        color: Color,
        style: StrokeStyle = StrokeStyle(lineWidth: 1),
    ) {
        self.init(shading: .color(color), style: style)
    }

    init(
        color: Color,
        lineWidth: CGFloat,
    ) {
        self.init(color: color, style: StrokeStyle(lineWidth: lineWidth))
    }
}
