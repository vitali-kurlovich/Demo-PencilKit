//
//  Created by Kurlovich Vitali on 7/29/26.
//

import PencilKit
import SwiftUI

@Animatable
struct TranslateAlongStrokePath: ViewModifier {
    /// The path to move along
    let strokePath: PKStrokePath

    /// The total time to interpolate between. The max value should always be 1.
    var phase: CGFloat

    func body(content: Content) -> some View {
        if let pos = interpolate(phase) {
            content.position(pos)
                .opacity(1 - phase * phase)
        } else {
            content
        }
    }

    private func interpolate(_ value: CGFloat) -> CGPoint? {
        if strokePath.isEmpty {
            return nil
        }

        let parametricValue = CGFloat(strokePath.count - 1) * value.clamped(to: 0 ... 1)

        return strokePath.interpolatedLocation(at: parametricValue)
    }
}

extension TranslateAlongStrokePath {
    init(_ stroke: PKStroke, phase: CGFloat) {
        self.init(strokePath: stroke.path, phase: phase)
    }
}
