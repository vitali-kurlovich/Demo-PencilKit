//
//  Created by Kurlovich Vitali on 7/26/26.
//

import SwiftData
import SwiftUI

@Model
final class LessonItem {
    var name: String

    init(name: String = "New Sketch") {
        self.name = name
    }
}

struct Lesson: Identifiable {
    let id: UUID
    let name: String
    let description: String

    var thumbnailName: String
    var steps: [LessonStep]
}

struct LessonStep: Identifiable {
    let id: UUID

    let name: String
    let description: String

    let imageName: String
    let strokeImage: String
}

@main
struct DemoPencilKitApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            LessonItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}
