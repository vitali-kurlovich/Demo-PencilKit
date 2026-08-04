//
//  SketchEditorModel.swift
//  DemoPencilKit
//
//  Created by Kurlovich Vitali on 8/1/26.
//

import PencilKit
import PhotosUI
import SwiftUI

// import SwiftData

@Observable
final class SketchEditorModel {
    var drawing: PKDrawing = .init()

    var selection: Set<UUID> = []

    let lesson: LessonItem

    init(lesson: LessonItem = .init()) {
        self.lesson = lesson
    }

    var presentInspector: Bool = false
    var selectedPhoto: PhotosPickerItem?

    var backgroundImage: Image?
    var backgroundScaleFactor: Float = 1.0

    var isDrawing: Bool = false
}

extension SketchEditorModel {
    var name: String {
        get {
            lesson.name
        }

        set {
            lesson.name = newValue
        }
    }

    var strokes: [PKStroke] {
        get {
            drawing.strokes
        }
        set {
            drawing.strokes = newValue
        }
    }
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
