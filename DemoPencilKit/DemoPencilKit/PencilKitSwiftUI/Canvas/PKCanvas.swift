//
//  Created by Kurlovich Vitali on 7/26/26.
//

import PencilKit
import SwiftUI

enum ToolUsing {
    case begin(tool: any PKTool)
    case end(tool: any PKTool)
}

struct PKCanvas: View {
    @Binding
    private var drawing: PKDrawing

    @Binding
    private var selection: Set<UUID>

    private let onDrawEvent: (PKDrawEvent) -> Void
    private let onDrawingChange: (PKDrawing) -> Void
    private let onSelectionChange: (Set<UUID>) -> Void
    private let onToolUsing: (ToolUsing) -> Void

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
            onToolUsing: { _ in },
        )
    }

    private init(drawing: Binding<PKDrawing>,
                 selection: Binding<Set<UUID>>,
                 onDrawEvent: @escaping (PKDrawEvent) -> Void,
                 onDrawingChange: @escaping (PKDrawing) -> Void,
                 onSelectionChange: @escaping (Set<UUID>) -> Void,
                 onToolUsing: @escaping (ToolUsing) -> Void)
    {
        _drawing = drawing
        _selection = selection
        self.onDrawEvent = onDrawEvent
        self.onDrawingChange = onDrawingChange
        self.onSelectionChange = onSelectionChange
        self.onToolUsing = onToolUsing
    }

    var body: some View {
        _PKCanvas(
            drawing: $drawing,
            selection: $selection,
            onDrawEvent: onDrawEvent,
            onDrawingChange: onDrawingChange,
            onSelectionChange: onSelectionChange,
            onToolUsing: onToolUsing,
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
            onToolUsing: onToolUsing,
        )
    }

    func onDrawingChange(_ onDrawingChange: @escaping (PKDrawing) -> Void) -> Self {
        PKCanvas(
            drawing: _drawing,
            selection: _selection,
            onDrawEvent: onDrawEvent,
            onDrawingChange: onDrawingChange,
            onSelectionChange: onSelectionChange,
            onToolUsing: onToolUsing,
        )
    }

    func onSelectionChange(_ onSelectionChange: @escaping (Set<UUID>) -> Void) -> Self {
        PKCanvas(
            drawing: _drawing,
            selection: _selection,
            onDrawEvent: onDrawEvent,
            onDrawingChange: onDrawingChange,
            onSelectionChange: onSelectionChange,
            onToolUsing: onToolUsing,
        )
    }

    func onTool(using onToolUsing: @escaping (ToolUsing) -> Void) -> Self {
        PKCanvas(
            drawing: _drawing,
            selection: _selection,
            onDrawEvent: onDrawEvent,
            onDrawingChange: onDrawingChange,
            onSelectionChange: onSelectionChange,
            onToolUsing: onToolUsing,
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
    private let onToolUsing: (ToolUsing) -> Void

    init(drawing: Binding<PKDrawing>,
         selection: Binding<Set<UUID>>,
         onDrawEvent: @escaping (PKDrawEvent) -> Void,
         onDrawingChange: @escaping (PKDrawing) -> Void,
         onSelectionChange: @escaping (Set<UUID>) -> Void,
         onToolUsing: @escaping (ToolUsing) -> Void)
    {
        _drawing = drawing
        _selection = selection
        self.onDrawEvent = onDrawEvent
        self.onDrawingChange = onDrawingChange
        self.onSelectionChange = onSelectionChange
        self.onToolUsing = onToolUsing
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

        invalidateToolPicker(canvas, context: context)

        debugPrint(#function, selection)
    }

    func makeCoordinator() -> PKCanvasCoordinator {
        PKCanvasCoordinator($drawing,
                            selection: $selection,
                            onDrawEvent: onDrawEvent,
                            onDrawingChange: onDrawingChange,
                            onSelectionChange: onSelectionChange,
                            onToolUsing: onToolUsing)
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
    let onToolUsing: (ToolUsing) -> Void

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
         onSelectionChange: @escaping (Set<UUID>) -> Void,
         onToolUsing: @escaping (ToolUsing) -> Void)
    {
        self.onDrawEvent = onDrawEvent
        self.onDrawingChange = onDrawingChange
        self.onSelectionChange = onSelectionChange
        self.onToolUsing = onToolUsing

        self.drawing = drawing
        self.selection = selection
    }

    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        if drawing.wrappedValue != canvasView.drawing {
            drawing.wrappedValue = canvasView.drawing
        }

        onDrawingChange(canvasView.drawing)
    }

    func canvasViewSelectionDidChange(_ canvasView: PKCanvasView) {
        onSelectionChange(canvasView.selection)
    }

    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        onToolUsing(.begin(tool: canvasView.tool))
    }

    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        onToolUsing(.end(tool: canvasView.tool))
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
