//
//  Created by Kurlovich Vitali on 7/29/26.
//

import PencilKit
import SwiftUI

@Observable
final class SketchEditorModel {
    var drawing: PKDrawing = .init()

    var selection: Set<UUID> = []

    var strokes: [PKStroke] {
        get {
            drawing.strokes
        }
        set {
            drawing.strokes = newValue
        }
    }

    var name: String = "New Sketch"

    var presentInspector: Bool = false
}

extension SketchEditorModel {
    func save() {
        let data = drawing.dataRepresentation()

        debugPrint("Data \(data.count)")
    }

    func rename() {}
}

struct SketchEditorScreen: View {
    @State
    private var model = SketchEditorModel()

    var body: some View {
        NavigationStack {
            PKCanvas($model.drawing, selection: $model.selection)
                .toolPicker(displayMode: .visible)
                .sketchEditorToolbar($model)

        }.inspector(isPresented: $model.presentInspector) {
            PKDrawingInspector(
                drawing: $model.drawing,
                selection: $model.selection,
            )
        }.navigationTitle($model.name)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct SketchEditorToolbar: ViewModifier {
    @Binding
    var model: SketchEditorModel

    func body(content: Self.Content) -> some View {
        content.toolbar {
            ToolbarItemGroup(placement: .confirmationAction) {
                Button("Save", systemImage: "square.and.arrow.down") {
                    model.save()
                }.buttonStyle(.borderedProminent)
            }

            ToolbarItemGroup(placement: .primaryAction) {
                Toggle(isOn: $model.presentInspector) {
                    Label("Inspect", systemImage: "sidebar.trailing")
                }
            }
        }
    }
}

extension View {
    func sketchEditorToolbar(_ model: Binding<SketchEditorModel>) -> some View {
        modifier(
            SketchEditorToolbar(model: model),
        )
    }
}

#Preview {
    NavigationStack {
        SketchEditorScreen()
    }
}
