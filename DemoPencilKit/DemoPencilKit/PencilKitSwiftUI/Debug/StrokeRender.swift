//
//  Created by Kurlovich Vitali on 7/27/26.
//

import Combine
import PencilKit
import SwiftUI

protocol StrokeRender {
    func draw(
        stroke: PKStroke,
        at index: Int,
        in context: GraphicsContext,
        size: CGSize,
    )
}

extension StrokeRender {
    func draw(
        stroke _: PKStroke,
        at _: Int,
        in _: GraphicsContext,
        size _: CGSize,
    ) {}
}

struct StrokeDrawing<Render: StrokeRender>: View {
    let render: Render

    @Binding
    var drawing: PKDrawing

    var body: some View {
        Canvas { context, size in
            for (index, stroke) in drawing.strokes.enumerated() {
                render.draw(stroke: stroke, at: index, in: context, size: size)
            }
        }.allowsHitTesting(false)
    }
}

struct DebugStrokeRender: StrokeRender {
    let options: Options

    init(options: Options = .all) {
        self.options = options
    }

    struct Options: OptionSet, Sendable {
        let rawValue: UInt8

        static let bounds: Self = .init(rawValue: 1 << 0)
        static let paths: Self = .init(rawValue: 1 << 1)

        static let all: Self = [.bounds, .paths]
    }

    func draw(
        stroke: PKStroke,
        at _: Int,
        in context: GraphicsContext,
        size _: CGSize,
    ) {
        if options.contains(.bounds) {
            let bounds = stroke.renderBounds
            let path = Path(roundedRect: bounds, cornerRadius: 0)

            context.stroke(path, with: .color(.blue), style: .init(lineWidth: 1))
        }

        if options.contains(.paths) {
            let path = Path(stroke.path.bezierRepresentation)

            context.stroke(path, with: .color(.red), style: .init(lineWidth: 1))
        }
    }
}
