//
//  Created by Kurlovich Vitali on 7/29/26.
//

import Foundation
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
    var backgroundScaleFactor: Float = 1.0
}

extension SketchEditorModel {
    var scaleEffectSize: CGSize {
        let scale = CGFloat(backgroundScaleFactor)
        return .init(width: scale, height: scale)
    }
}

extension SketchEditorModel {
    func save() {
        let data = drawing.dataRepresentation()

        debugPrint("Data \(data.count)")
    }

    func rename() {}
}

struct SketchEditorScreen: View {
    @Binding
    private var model: SketchEditorModel

    init(_ model: Binding<SketchEditorModel>) {
        _model = model
    }

    var body: some View {
        PKCanvas($model.drawing, selection: $model.selection)
            .toolPicker(displayMode: .visible)
            .sketchEditorToolbar($model)
            .background {
                if let image = model.backgroundImage {
                    image.scaleEffect(model.scaleEffectSize)
                }
            }

            .inspector(isPresented: $model.presentInspector) {
                PKDrawingInspector(
                    drawing: $model.drawing,
                    selection: $model.selection,
                )

            }.navigationTitle($model.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationSubtitle(
                model.backgroundScaleFactor
                    .formatted(.percent.precision(.fractionLength(0))),
            )
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
                Spacer()
                Slider(value: $model.backgroundScaleFactor,
                       in: 0.2 ... 2.0, step: 0.1).frame(width: 330)
                    .disabled(
                        model.backgroundImage == nil,
                    )

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
    @Previewable @State
    var model = SketchEditorModel()

    NavigationStack {
        SketchEditorScreen($model)
    }.onAppear {
        model.backgroundImage = Image("Rabbit")
    }
}
