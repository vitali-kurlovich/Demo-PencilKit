//
//  Created by Kurlovich Vitali on 7/29/26.
//

import SwiftUI

struct MainView: View {
    @State
    var model: SketchEditorModel = .init()

    var body: some View {
        SketchEditorScreen($model)
    }
}

#Preview {
    MainView()
}
