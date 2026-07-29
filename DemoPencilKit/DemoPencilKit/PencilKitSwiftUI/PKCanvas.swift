//
//  Created by Kurlovich Vitali on 7/26/26.
//

import PencilKit
import SwiftUI

struct PKCanvas {
    @Environment(\.toolPickerDisplayMode)
    var toolPickerDisplayMode: PKToolPickerDisplayMode

    @Binding
    private var drawing: PKDrawing

    private let onDrawEvent: (PKDrawEvent) -> Void
    private let onDrawingChange: (PKDrawing) -> Void

    init(_ drawing: Binding<PKDrawing>) {
        self.init(
            drawing: drawing,
            onDrawEvent: { _ in },
            onDrawingChange: { _ in },
        )
    }

    private init(drawing: Binding<PKDrawing>,
                 onDrawEvent: @escaping (PKDrawEvent) -> Void,
                 onDrawingChange: @escaping (PKDrawing) -> Void)
    {
        _drawing = drawing
        self.onDrawEvent = onDrawEvent
        self.onDrawingChange = onDrawingChange
    }
}

extension PKCanvas {
    func onDraw(_ onDrawEvent: @escaping (PKDrawEvent) -> Void) -> Self {
        PKCanvas(
            drawing: _drawing,
            onDrawEvent: onDrawEvent,
            onDrawingChange: onDrawingChange,
        )
    }

    func onDrawingChange(_ onDrawingChange: @escaping (PKDrawing) -> Void) -> Self {
        PKCanvas(
            drawing: _drawing,
            onDrawEvent: onDrawEvent,
            onDrawingChange: onDrawingChange,
        )
    }
}

extension PKCanvas: UIViewRepresentable {
    func makeUIView(context: Self.Context) -> PKCanvasView {
        debugPrint(#function)

        let coordinator = context.coordinator

        let container = PKCanvasView(frame: .zero)

        container.drawing = drawing

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

        debugPrint(#function)
    }

    func makeCoordinator() -> PKCanvasCoordinator {
        PKCanvasCoordinator($drawing,
                            onDrawEvent: onDrawEvent,
                            onDrawingChange: onDrawingChange)
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

private extension PKCanvas {
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

final class PKCanvasCoordinator: NSObject, PKCanvasViewDelegate {
    var canvasContainer: PKCanvasView!

    let toolPicker = PKToolPicker()

    let onDrawEvent: (PKDrawEvent) -> Void
    let onDrawingChange: (PKDrawing) -> Void

    private let drawing: Binding<PKDrawing>

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
         onDrawEvent: @escaping (PKDrawEvent) -> Void,
         onDrawingChange: @escaping (PKDrawing) -> Void)
    {
        self.onDrawEvent = onDrawEvent
        self.onDrawingChange = onDrawingChange

        self.drawing = drawing
    }

    func canvasViewDrawingDidChange(_ canvas: PKCanvasView) {
        debugPrint("\(#function) drawing:\(canvas.drawing.strokes)")

        drawing.wrappedValue = canvas.drawing

        onDrawingChange(canvas.drawing)
    }

    func canvasViewDidFinishRendering(_: PKCanvasView) {
        debugPrint(#function)
        // canvasObservation.proxy = PKCanvasProxy(canvasView)
    }

    func canvasViewDidBeginUsingTool(_ canvas: PKCanvasView) {
        debugPrint("\(#function) drawing:\(canvas.drawing.strokes)")

        // canvasObservation.proxy = PKCanvasProxy(canvasView)
    }

    func canvasViewDidEndUsingTool(_: PKCanvasView) {
        debugPrint(#function)
        // canvasObservation.proxy = PKCanvasProxy(canvasView)
    }

    func canvasViewSelectionDidChange(_: PKCanvasView) {
        debugPrint(#function)
        // canvasObservation.proxy = PKCanvasProxy(canvasView)
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
