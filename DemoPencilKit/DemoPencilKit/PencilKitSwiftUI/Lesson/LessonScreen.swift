//
//  Created by Kurlovich Vitali on 7/29/26.
//

import Observation
import PencilKit
import SwiftUI

@Observable
class LessonModel {
    var drawing: PKDrawing = .init()
}

struct LessonScreen: View {
    @State
    var model = LessonModel()

    var body: some View {
        PKCanvas($model.drawing).onTool(using: { _ in
        })
        .toolPicker(displayMode: .visible)
    }
}

#Preview {
    LessonScreen()
}
