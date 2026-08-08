//
//  DemoDrawingToolbar.swift
//  DemoPencilKit
//
//  Created by Kurlovich Vitali on 8/8/26.
//

import SwiftUI

extension View {
    func demoDrawingToolbar(options: Binding<DemoDrawingAnimation.AnimationOptions>, displayMode: Binding<PKToolPickerDisplayMode>) -> some View {
        modifier(
            DemoDrawingToolbar(options: options, displayMode: displayMode),
        )
    }
}

struct DemoDrawingToolbar: ViewModifier {
    typealias AnimationOptions = DemoDrawingAnimation.AnimationOptions

    @Binding
    var options: AnimationOptions // = .all

    @Binding
    var displayMode: PKToolPickerDisplayMode

    func body(content: Self.Content) -> some View {
        content.toolbar {
            ToolbarItemGroup(placement: .confirmationAction) {
                Toggle(
                    "Pencil Tools",
                    systemImage: "inset.filled.bottomhalf.tophalf.rectangle",
                    isOn: .init(get: {
                        displayMode == .visible
                    }, set: { on in
                        displayMode = on ? .visible : .hidden
                    }),
                )
            }

            ToolbarItemGroup(placement: .automatic) {
                Toggle(
                    "Stroke",
                    systemImage: "pencil.and.scribble",
                    isOn: .init(get: {
                        options.contains(.animatePKStroke)
                    }, set: { on in
                        if on {
                            options.insert(.animatePKStroke)
                        } else {
                            options.remove(.animatePKStroke)
                        }
                    }),
                )

                Toggle(
                    "Path",
                    systemImage: "scribble",
                    isOn: .init(get: {
                        options.contains(.showPath)
                    }, set: { on in
                        if on {
                            options.insert(.showPath)
                        } else {
                            options.remove(.showPath)
                        }
                    }),
                )

                Toggle(
                    "Target",
                    systemImage: "scope",
                    isOn: .init(get: {
                        options.contains(.showTarget)
                    }, set: { on in
                        if on {
                            options.insert(.showTarget)
                        } else {
                            options.remove(.showTarget)
                        }
                    }),
                )
            }
        }
    }
}
