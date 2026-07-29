//
//  PKToolPickerDisplayMode.swift
//  DemoPencilKit
//
//  Created by Kurlovich Vitali on 7/27/26.
//

import PencilKit
import SwiftUI

extension EnvironmentValues {
    /// Generates the underlying key and boilerplate automatically
    @Entry var toolPickerDisplayMode: PKToolPickerDisplayMode = .hidden
}

enum PKToolPickerDisplayMode {
    case visible
    case hidden

    mutating func toggle() {
        switch self {
        case .visible:
            self = .hidden
        case .hidden:
            self = .visible
        }
    }
}

extension View {
    func toolPicker(displayMode: PKToolPickerDisplayMode) -> some View {
        environment(\.toolPickerDisplayMode, displayMode)
    }
}
