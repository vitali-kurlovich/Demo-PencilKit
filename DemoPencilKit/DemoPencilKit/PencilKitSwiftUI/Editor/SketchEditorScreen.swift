//
//  Created by Kurlovich Vitali on 7/29/26.
//

import PencilKit
import PhotosUI
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
    var selectedPhoto: PhotosPickerItem?

    var backgroundImage: Image?
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
        PKCanvas($model.drawing, selection: $model.selection)
            .toolPicker(displayMode: .visible)
            .sketchEditorToolbar($model)
            .background {
                if let image = model.backgroundImage {
                    image
                }
            }

            .inspector(isPresented: $model.presentInspector) {
                PKDrawingInspector(
                    drawing: $model.drawing,
                    selection: $model.selection,
                )

            }.navigationTitle($model.name)
            .navigationBarTitleDisplayMode(.inline)
            .task(id: model.selectedPhoto) {
                guard let selectedPhoto = model.selectedPhoto else {
                    return
                }

                if selectedPhoto.supportedContentTypes
                    .contains(where: { $0.conforms(to: .image)
                    })
                {
                    debugPrint("Load image")

                    model.backgroundImage = try? await selectedPhoto
                        .loadTransferable(type: Image.self)
                }
            }
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
                PhotosPicker(
                    selection: $model.selectedPhoto,
                    //  matching: .all(of: [.images, .screenshots]),
                ) {
                    Image(systemName: "photo")
                }

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
