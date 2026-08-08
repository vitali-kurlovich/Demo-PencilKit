//
//  Created by Kurlovich Vitali on 8/5/26.
//

import SwiftUI

struct CanvasSvgVisitor: SvgVisitor {
    let context: GraphicsContext
    let size: CGSize

    func visit(with context: inout GraphicsContext, tag: PathTag) {
        let path = Path(tag.commands)

        context.fill(path, with: .color(.red))
    }
}

struct SVGView: View {
    let document: SvgDocument

    var viewBox: CGRect {
        document.svg.viewBox
    }

    var body: some View {
        Canvas { context, size in
            let visitor = SvgDocumentVisitor(visitor: CanvasSvgVisitor(context: context, size: size),
                                             document: document)

            visitor.visit()

        }.frame(idealWidth: viewBox.width, idealHeight: viewBox.height)
    }
}

struct SvgPathView: View {
    let viewBox: CGRect
    let shading: ShadingStyle
    let path: Path

    var body: some View {
        Canvas {
            context,
            size in
            let transform = CGAffineTransform
                .fit(from: viewBox, to: CGRect(origin: .zero, size: size))

            var ctx = context
            ctx.transform = transform

            if let fill = shading.fill {
                ctx.fill(path, with: fill.shading, style: fill.style)
            }

            if let stroke = shading.stroke {
                ctx.stroke(path, with: stroke.shading, style: stroke.style)
            }

        }.frame(idealWidth: viewBox.width, idealHeight: viewBox.height)
    }
}

#Preview {
    SvgPathView(
        viewBox: CGRect(x: 0, y: 0, width: 728, height: 1200),
        shading: ShadingStyle(
            fill: .init(color: .accentColor),
            stroke: .init(color: .orange, lineWidth: 4),
        ),

        path: Path(path: "M340.01,689.15L343.02,694.99C339.18,696.79 339.275,739.237 340.05,740.59C343.19,746.07 344.59,749.97 358.39,745.91C381.392,739.143 405.67,739.17 426.11,753.66C436.717,761.187 444.91,771.173 450.69,783.62C466.743,792.08 463.295,842.062 456.88,850.62C409.661,913.609 369.147,849.587 368,848.18C363.67,842.868 356.027,866.65 359.965,926.748C362.973,972.642 364.543,1055.787 304.15,1103.12C303.791,1103.401 303.931,1103.974 304.38,1104.06C347.447,1112.333 389.308,1139.554 391.7,1155.58C394.594,1174.973 375.46,1180.03 275.83,1178.59C273.463,1178.597 271.147,1178.513 268.88,1178.34C253.86,1177.207 238.15,1175.593 221.75,1173.5C211.583,1172.2 201.797,1170.26 192.39,1167.68C173.13,1162.41 152.2,1152.1 146.22,1131.31C144.453,1125.157 142.557,1116.967 140.53,1106.74C137.597,1091.98 135.4,1075.21 133.94,1056.43C131.247,1021.91 132.243,986.643 136.93,950.63C139.463,931.13 143.32,912.003 148.5,893.25C152.42,879.07 155.553,868.197 157.9,860.63C159.54,855.323 161.88,848.747 164.92,840.9C174.28,816.7 187.68,793.17 204.54,772.54C223.733,749.06 246.657,729.653 273.31,714.32C292.683,703.167 313.347,694.987 335.3,689.78C336.453,689.507 338.023,689.297 340.01,689.15Z"),
    )
}
