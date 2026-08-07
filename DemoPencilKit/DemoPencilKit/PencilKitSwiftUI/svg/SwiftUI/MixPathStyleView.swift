//
//  Created by Kurlovich Vitali on 8/7/26.
//

import SwiftUI

@Animatable
struct MixPathStyleView: View {
    var phase: CGFloat

    let viewBox: CGRect
    let fromStyle: PathStyle
    let toStyle: PathStyle
    let path: Path

    var style: PathStyle {
        fromStyle.mix(with: toStyle, by: phase)
    }

    var body: some View {
        PathShapeView(viewBox: viewBox, style: style, path: path)
    }
}

#Preview {
    @Previewable @State
    var phase: CGFloat = 0

    let viewBox = CGRect(origin: .zero, size: CGSize(width: 250, height: 250))

    let roundedRect = CGRect(x: (250 - 150) / 2, y: (250 - 150) / 2, width: 150, height: 150)

    let cornerSize = CGSize(width: 44, height: 44)

    let path = Path(
        roundedRect: roundedRect,
        cornerSize: cornerSize,
        style: .continuous,
    )

    let fromStroke = StrokeStyle(lineWidth: 2, dash: [15, 5])
    let toStroke = StrokeStyle(lineWidth: 2, dash: [15, 5], dashPhase: 40)

    let fromStyle = PathStyle(
        fill: .init(color: .orange),
        stroke: .init(color: .indigo, style: fromStroke, widthMode: .absolute),
    )

    let toStyle = PathStyle(
        fill: .init(color: .clear),
        stroke: .init(color: .indigo, style: toStroke, widthMode: .absolute),
    )

    MixPathStyleView(
        phase: phase,
        viewBox: viewBox,
        fromStyle: fromStyle,
        toStyle: toStyle,
        path: path,
    ).overlay(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
        Button("Toggle") {
            withAnimation {
                if phase < 1 {
                    phase = 1
                } else {
                    phase = 0
                }
            }
        }
    }
}
