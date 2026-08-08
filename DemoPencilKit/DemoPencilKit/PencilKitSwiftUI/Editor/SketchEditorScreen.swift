//
//  Created by Kurlovich Vitali on 7/29/26.
//

import Foundation
import PencilKit
import PhotosUI
import SwiftData
import SwiftUI

struct SketchEditorScreen: View {
    @Environment(\.modelContext) private var modelContext

    @Binding
    private var model: SketchEditorModel

    @State
    var stepPhase: StepPhase = .initial

    init(_ model: Binding<SketchEditorModel>) {
        _model = model
    }

    var body: some View {
        PKCanvas($model.drawing, selection: $model.selection)
            .onTool(using: { event in
                withAnimation {
                    switch event {
                    case .begin:
                        model.isDrawing = true

                        stepPhase = .highlight
                    case .end:
                        model.isDrawing = false
                        stepPhase = .started
                    }
                }
            })

            .toolPicker(displayMode: .visible)
            .sketchEditorToolbar($model)
            .background {
                if let image = model.backgroundImage {
                    image
                        .scaleEffect(model.scaleEffectSize)
                }
            }
            .overlay {
                Step_O8View(state: $stepPhase)
                    .scaleEffect(model.scaleEffectSize)
                    .allowsHitTesting(false)
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

#Preview {
    @Previewable @State
    var model = SketchEditorModel(lesson: LessonItem())

    NavigationStack {
        SketchEditorScreen($model)
    }.onAppear {
        model.backgroundImage = Image("Rabbit/Step_08")
    }
}
