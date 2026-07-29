//
//  Created by Kurlovich Vitali on 7/26/26.
//

import PencilKit
import SwiftUI

struct PKCanvas: View {
    @Binding
    private var drawing: PKDrawing

    @Binding
    private var selection: Set<UUID>

    private let onDrawEvent: (PKDrawEvent) -> Void
    private let onDrawingChange: (PKDrawing) -> Void
    private let onSelectionChange: (Set<UUID>) -> Void

    @State
    private var defaultSelection: Set<UUID> = []

    init(
        _ drawing: Binding<PKDrawing>,
    ) {
        let state = State(initialValue: Set<UUID>())

        self.init(
            drawing,
            selection: state.projectedValue,
        )

        _defaultSelection = state
    }

    init(
        _ drawing: Binding<PKDrawing>,
        selection: Binding<Set<UUID>>,
    ) {
        self.init(
            drawing: drawing,
            selection: selection,
            onDrawEvent: { _ in },
            onDrawingChange: { _ in },
            onSelectionChange: { _ in },
        )
    }

    private init(drawing: Binding<PKDrawing>,
                 selection: Binding<Set<UUID>>,
                 onDrawEvent: @escaping (PKDrawEvent) -> Void,
                 onDrawingChange: @escaping (PKDrawing) -> Void,
                 onSelectionChange: @escaping (Set<UUID>) -> Void)
    {
        _drawing = drawing
        _selection = selection
        self.onDrawEvent = onDrawEvent
        self.onDrawingChange = onDrawingChange
        self.onSelectionChange = onSelectionChange
    }

    var body: some View {
        _PKCanvas(
            drawing: $drawing,
            selection: $selection,
            onDrawEvent: onDrawEvent,
            onDrawingChange: onDrawingChange,
            onSelectionChange: onSelectionChange,
        )
    }
}

extension PKCanvas {
    func onDraw(_ onDrawEvent: @escaping (PKDrawEvent) -> Void) -> Self {
        PKCanvas(
            drawing: _drawing,
            selection: _selection,
            onDrawEvent: onDrawEvent,
            onDrawingChange: onDrawingChange,
            onSelectionChange: onSelectionChange,
        )
    }

    func onDrawingChange(_ onDrawingChange: @escaping (PKDrawing) -> Void) -> Self {
        PKCanvas(
            drawing: _drawing,
            selection: _selection,
            onDrawEvent: onDrawEvent,
            onDrawingChange: onDrawingChange,
            onSelectionChange: onSelectionChange,
        )
    }

    func onSelectionChange(_ onSelectionChange: @escaping (Set<UUID>) -> Void) -> Self {
        PKCanvas(
            drawing: _drawing,
            selection: _selection,
            onDrawEvent: onDrawEvent,
            onDrawingChange: onDrawingChange,
            onSelectionChange: onSelectionChange,
        )
    }
}

private struct _PKCanvas {
    @Environment(\.toolPickerDisplayMode)
    var toolPickerDisplayMode: PKToolPickerDisplayMode

    @Binding
    private var drawing: PKDrawing

    @Binding
    private var selection: Set<UUID>

    private let onDrawEvent: (PKDrawEvent) -> Void
    private let onDrawingChange: (PKDrawing) -> Void
    private let onSelectionChange: (Set<UUID>) -> Void

    init(
        _ drawing: Binding<PKDrawing>,
        selection: Binding<Set<UUID>>,
    ) {
        self.init(
            drawing: drawing,
            selection: selection,
            onDrawEvent: { _ in },
            onDrawingChange: { _ in },
            onSelectionChange: { _ in },
        )
    }

    init(drawing: Binding<PKDrawing>,
         selection: Binding<Set<UUID>>,
         onDrawEvent: @escaping (PKDrawEvent) -> Void,
         onDrawingChange: @escaping (PKDrawing) -> Void,
         onSelectionChange: @escaping (Set<UUID>) -> Void)
    {
        _drawing = drawing
        _selection = selection
        self.onDrawEvent = onDrawEvent
        self.onDrawingChange = onDrawingChange
        self.onSelectionChange = onSelectionChange
    }
}

extension _PKCanvas: UIViewRepresentable {
    func makeUIView(context: Self.Context) -> PKCanvasView {
        debugPrint(#function)

        let coordinator = context.coordinator

        let container = PKCanvasView(frame: .zero)

        container.drawing = drawing
        container.selection = selection

        coordinator.canvasContainer = container

        container.drawingPolicy = .anyInput
        container.isDrawingEnabled = true
        container.delegate = coordinator

        container.backgroundColor = .clear

        container.drawingGestureRecognizer.addTarget(coordinator,
                                                     action: #selector(PKCanvasCoordinator.onDrawGesture(gesture:)))

        return container
    }

    func updateUIView(_ canvas: PKCanvasView, context: Context) {
        if canvas.drawing != drawing {
            canvas.drawing = drawing
        }

        if canvas.selection != selection {
            canvas.selection = selection
        }

        invalidateToolPicker(canvas, context: context)

        debugPrint(#function)
    }

    func makeCoordinator() -> PKCanvasCoordinator {
        PKCanvasCoordinator($drawing, selection: $selection,
                            onDrawEvent: onDrawEvent,
                            onDrawingChange: onDrawingChange,
                            onSelectionChange: onSelectionChange)
    }

    static func dismantleUIView(_ canvas: PKCanvasView, coordinator: PKCanvasCoordinator) {
        debugPrint(#function)
        canvas.delegate = nil

        canvas.drawingGestureRecognizer
            .removeTarget(
                coordinator,
                action: #selector(PKCanvasCoordinator.onDrawGesture(gesture:)),
            )
    }
}

private extension _PKCanvas {
    func invalidateToolPicker(_ canvas: PKCanvasView, context: Context) {
        let toolPicker = context.coordinator.toolPicker

        switch toolPickerDisplayMode {
        case .visible:
            if !toolPicker.isVisible {
                toolPicker.setVisible(true, forFirstResponder: canvas)
                toolPicker.addObserver(canvas)

                // Critical step: Make canvas the first responder to show the tool picker
                DispatchQueue.main.async {
                    canvas.becomeFirstResponder()
                }
            }
        case .hidden:
            if toolPicker.isVisible {
                toolPicker.setVisible(false, forFirstResponder: canvas)
                toolPicker.removeObserver(canvas)
            }
        }
    }
}

private final class PKCanvasCoordinator: NSObject, PKCanvasViewDelegate {
    var canvasContainer: PKCanvasView!

    let toolPicker = PKToolPicker()

    let onDrawEvent: (PKDrawEvent) -> Void
    let onDrawingChange: (PKDrawing) -> Void

    let onSelectionChange: (Set<UUID>) -> Void

    private let drawing: Binding<PKDrawing>
    private let selection: Binding<Set<UUID>>

    private var lastDrawEvent: PKDrawEvent = .init(
        previousLocation: .zero,
        location: .zero,
        phase: .ended,
    ) {
        didSet {
            onDrawEvent(lastDrawEvent)
        }
    }

    init(_ drawing: Binding<PKDrawing>,
         selection: Binding<Set<UUID>>,
         onDrawEvent: @escaping (PKDrawEvent) -> Void,
         onDrawingChange: @escaping (PKDrawing) -> Void,
         onSelectionChange: @escaping (Set<UUID>) -> Void)
    {
        self.onDrawEvent = onDrawEvent
        self.onDrawingChange = onDrawingChange
        self.onSelectionChange = onSelectionChange

        self.drawing = drawing
        self.selection = selection
    }

    func canvasViewDrawingDidChange(_ canvas: PKCanvasView) {
        debugPrint("\(#function) drawing:\(canvas.drawing.strokes)")

        if drawing.wrappedValue != canvas.drawing {
            drawing.wrappedValue = canvas.drawing
        }

        onDrawingChange(canvas.drawing)
    }

    func canvasViewSelectionDidChange(_ canvas: PKCanvasView) {
        debugPrint(#function)

        if selection.wrappedValue != canvas.selection {
            selection.wrappedValue = canvas.selection
        }

        onSelectionChange(canvas.selection)
    }
}

extension PKCanvasCoordinator {
    @objc
    func onDrawGesture(gesture: UIGestureRecognizer) {
        let location = gesture.location(in: gesture.view)

        switch gesture.state {
        case .possible:
            break

        case .began:
            let event = PKDrawEvent(
                previousLocation: location,
                location: location,
                phase: .began,
            )

            lastDrawEvent = event

        case .changed:
            let event = PKDrawEvent(
                previousLocation: lastDrawEvent.location,
                location: location,
                phase: .move,
            )

            lastDrawEvent = event

        case .ended:
            let event = PKDrawEvent(
                previousLocation: lastDrawEvent.location,
                location: location,
                phase: .ended,
            )

            lastDrawEvent = event

        case .cancelled:
            break

        case .failed:
            break

        @unknown default:
            break
        }
    }
}
