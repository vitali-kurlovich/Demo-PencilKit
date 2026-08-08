//
//  Created by Kurlovich Vitali on 8/8/26.
//

import PencilKit
import SwiftUI

@Animatable
struct StrokePath: View {
    let stroke: PKStroke

    let color: Color
    let style: StrokeStyle

    var phase: CGFloat

    init(
        stroke: PKStroke,
        color: Color = .accentColor,
        style: StrokeStyle = StrokeStyle(
            lineWidth: 4,
            lineCap: .round,
            lineJoin: .round,
            miterLimit: 10,
            dash: [15, 15],
            dashPhase: 0,
        ),
        phase: CGFloat,
    ) {
        self.stroke = stroke
        self.color = color
        self.style = style
        self.phase = phase
    }

    var body: some View {
        let cgPath = stroke.path.bezierRepresentation

        let path = Path(cgPath).trimmedPath(from: 0, to: phase)

        path.stroke(color, style: style)
    }
}
