//
//  Created by Kurlovich Vitali on 7/29/26.
//

import PencilKit
import SwiftUI

struct PKStrokesEditor: View {
    @Binding
    var strokes: [PKStroke]

    @Binding
    var selection: Set<UUID>

    @State private var editMode: EditMode = .active

    var body: some View {
        List {
            ForEach(
                $strokes,
                id: \.id,
                editActions: [.move, .delete],
            ) { stroke in
                Text("\(stroke.id)").id(stroke.id)
            }
        }.environment(\.editMode, $editMode)
    }
}

#Preview {
    @Previewable @State
    var model = SketchEditorModel()
    HStack {
        PKCanvas($model.drawing,
                 selection: $model.selection)
            .toolPicker(displayMode: .visible)
        PKStrokesEditor(strokes: $model.strokes,
                        selection: $model.selection)
    }
}
