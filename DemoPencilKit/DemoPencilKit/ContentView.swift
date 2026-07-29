//
//  Created by Kurlovich Vitali on 7/26/26.
//

import PencilKit
import SwiftUI

struct ContentView: View {
    @State
    var drawing = PKDrawing()

    var body: some View {
        PKCanvas($drawing)
            .toolPicker(displayMode: .visible)
    }
}

#Preview {
    ContentView()
}
