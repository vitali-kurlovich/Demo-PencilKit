//
//  Created by Kurlovich Vitali on 7/29/26.
//

import Observation
import PencilKit
import SwiftUI

@Animatable
struct PKCanvasStroke: View {
    let stroke: PKStroke
    var phase: CGFloat

    var body: some View {
        _PKCanvasStroke(_stroke: stroke, phase: phase)
    }
}

private struct _PKCanvasStroke {
    let _stroke: PKStroke

    let phase: CGFloat

    var stroke: PKStroke {
        let value = CGFloat(_stroke.path.count - 1) * phase.clamped(to: 0 ... 1)
        return _stroke.substroke(range: 0 ... value)
    }
}

extension _PKCanvasStroke: UIViewRepresentable {
    func makeUIView(context _: Self.Context) -> PKCanvasView {
        let view = PKCanvasView(frame: .zero)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        view.drawing.strokes = [stroke]
        return view
    }

    func updateUIView(_ canvas: PKCanvasView, context _: Context) {
        canvas.drawing.strokes = [stroke]
    }
}
