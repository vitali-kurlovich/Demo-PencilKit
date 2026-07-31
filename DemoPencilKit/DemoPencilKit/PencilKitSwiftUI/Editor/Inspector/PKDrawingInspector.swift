//
//  Created by Kurlovich Vitali on 7/29/26.
//

import PencilKit
import SwiftUI

struct PKDrawingInspector: View {
    @Binding
    var drawing: PKDrawing

    @Binding
    var selection: Set<UUID>

    var body: some View {
        if drawing.strokes.isEmpty {
            ContentUnavailableView {
                Label("Nothing to edit", systemImage: "scribble.variable")
            } description: {
                Text("Editable items will appear here.")
            }
        } else {
            PKStrokesEditor(strokes: $drawing.strokes, selection: $selection)
        }
    }
}
