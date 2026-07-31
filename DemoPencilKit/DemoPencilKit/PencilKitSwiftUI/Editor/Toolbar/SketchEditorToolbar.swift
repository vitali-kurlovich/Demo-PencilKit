//
//  Created by Kurlovich Vitali on 7/31/26.
//

import PhotosUI
import SwiftUI

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
