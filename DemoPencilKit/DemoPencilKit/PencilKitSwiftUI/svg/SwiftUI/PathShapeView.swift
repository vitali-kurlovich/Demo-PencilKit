//
//  Created by Kurlovich Vitali on 8/7/26.
//

import SwiftUI

struct PathShapeView: View {
    let viewBox: CGRect
    let style: PathStyle
    let path: Path

    var body: some View {
        Canvas {
            context,
            size in
            let transform = CGAffineTransform
                .center(from: viewBox, to: CGRect(origin: .zero, size: size))

            var ctx = context
            ctx.transform = context.transform.concatenating(transform)

            let shading = ShadingStyle(style.unscaleIfNeeds(transform))

            if let fill = shading.fill {
                ctx.fill(path, with: fill.shading, style: fill.style)
            }

            if let stroke = shading.stroke {
                ctx.stroke(path, with: stroke.shading, style: stroke.style)
            }

        }.frame(width: viewBox.width * 2, height: viewBox.height * 2)
    }
}

#Preview {
    let viewBox = CGRect(x: 0, y: 0, width: 728, height: 1200) // .init(width: 250, height: 250)

    let roundedRect = CGRect(x: (250 - 150) / 2, y: (250 - 150) / 2, width: 150, height: 150)

    let cornerSize = CGSize(width: 44, height: 44)

    let path = Path(
        roundedRect: roundedRect,
        cornerSize: cornerSize,
        style: .continuous,
    )

    let stroke = StrokeStyle(lineWidth: 2, dash: [15, 5])

    let style = PathStyle(
        fill: .init(color: .orange),
        stroke: .init(color: .indigo, style: stroke),
    )

    PathShapeView(
        viewBox: viewBox,
        style: style,
        path: .step_08,
    )
    .scaleEffect(0.5)
    .background {
        Color.mint
    }
}
