//
//  Created by Kurlovich Vitali on 8/6/26.
//

import struct SwiftUI.Color
import struct SwiftUI.FillStyle
import struct SwiftUI.GraphicsContext

public struct FillShading: Sendable {
    public var shading: GraphicsContext.Shading
    public var style: FillStyle

    public init(shading: GraphicsContext.Shading, style: FillStyle = FillStyle()) {
        self.shading = shading
        self.style = style
    }
}

public extension FillShading {
    init(color: Color, style: FillStyle = FillStyle()) {
        self.init(shading: .color(color), style: style)
    }
}
