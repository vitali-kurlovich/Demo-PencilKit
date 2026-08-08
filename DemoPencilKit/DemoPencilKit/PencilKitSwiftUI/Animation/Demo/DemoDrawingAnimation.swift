//
//  Created by Kurlovich Vitali on 8/8/26.
//

import PencilKit
import SwiftUI

struct DemoDrawingAnimation: View {
    struct AnimationOptions: OptionSet {
        var rawValue: Int8

        static let animatePKStroke = Self(rawValue: 1 << 0)
        static let showPath = Self(rawValue: 1 << 1)
        static let showTarget = Self(rawValue: 1 << 2)

        static let all: Self = [.animatePKStroke, .showPath, .showTarget]
    }

    @State
    private var displayMode: PKToolPickerDisplayMode = .visible

    @State
    private var drawing: PKDrawing = .init()

    @State
    private var stroke: PKStroke?

    @State
    private var phase: CGFloat = 0

    @State
    private var options: AnimationOptions = .all

    var body: some View {
        PKCanvas($drawing).onDrawingChange { _ in
            if drawing.strokes.isEmpty == false {
                stroke = drawing.strokes.last
                drawing.strokes.removeLast()

                phase = 0
            }

            withAnimation(.easeInOut(duration: 1)) {
                phase = 1
            }
        }
        .overlay {
            if options.contains(.animatePKStroke) {
                if var lastStroke = stroke {
                    PKCanvasStroke(stroke: lastStroke, phase: phase)
                }
            }
        }.overlay {
            if let lastStroke = stroke {
                if options.contains(.showPath) {
                    StrokePath(stroke: lastStroke, phase: phase)
                }

                if options.contains(.showTarget) {
                    Image(systemName: "circle.circle")
                        .opacity(0.5)
                        .scaleEffect(2)
                        .modifier(
                            TranslateAlongStrokePath(
                                strokePath: lastStroke.path,
                                phase: phase,
                            ),
                        )
                }
            }
        }
        .toolPicker(displayMode: displayMode)
        .demoDrawingToolbar(options: $options, displayMode: $displayMode)
    }
}

#Preview {
    @Previewable @State
    var path = NavigationPath()

    NavigationStack(path: $path) {
        DemoDrawingAnimation()
    }
}
