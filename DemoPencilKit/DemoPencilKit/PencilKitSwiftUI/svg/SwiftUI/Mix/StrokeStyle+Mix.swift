//
//  Created by Kurlovich Vitali on 8/7/26.
//

import enum SwiftUI.CGLineCap
import enum SwiftUI.CGLineJoin
import struct SwiftUI.StrokeStyle

extension CGLineCap {
    func mix(with other: Self, by fraction: Double) -> Self {
        fraction > 0.5 ? other : self
    }
}

extension CGLineJoin {
    func mix(with other: Self, by fraction: Double) -> Self {
        fraction > 0.5 ? other : self
    }
}

extension StrokeStyle {
    func mix(with other: Self, by fraction: Double) -> Self {
        let lineWidth = lineWidth.mix(with: other.lineWidth, by: fraction)
        let lineCap = lineCap.mix(with: other.lineCap, by: fraction)
        let lineJoin = lineJoin.mix(with: other.lineJoin, by: fraction)
        let miterLimit = miterLimit.mix(with: other.miterLimit, by: fraction)

        let dash = dash.mix(with: other.dash, by: fraction)
        let dashPhase = dashPhase.mix(with: other.dashPhase, by: fraction)

        return .init(
            lineWidth: lineWidth,
            lineCap: lineCap,
            lineJoin: lineJoin,
            miterLimit: miterLimit,
            dash: dash,
            dashPhase: dashPhase,
        )
    }
}
