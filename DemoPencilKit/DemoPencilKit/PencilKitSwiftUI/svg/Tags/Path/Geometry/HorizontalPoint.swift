//
//  Created by Kurlovich Vitali on 8/4/26.
//

struct HorizontalPoint: Sendable, Hashable {
    var x: Double
}

struct HorizontalVector: Sendable, Hashable {
    var dx: Double
}

extension HorizontalPoint {
    static func + (lhs: HorizontalPoint, rhs: HorizontalVector) -> HorizontalPoint {
        .init(x: lhs.x + rhs.dx)
    }

    static func - (lhs: HorizontalPoint, rhs: HorizontalVector) -> HorizontalPoint {
        .init(x: lhs.x - rhs.dx)
    }
}

extension HorizontalPoint {
    static func - (lhs: HorizontalPoint, rhs: HorizontalPoint) -> HorizontalVector {
        .init(dx: lhs.x - rhs.x)
    }
}

extension Point {
    static func + (lhs: Point, rhs: HorizontalVector) -> Point {
        .init(x: lhs.x + rhs.dx, y: lhs.y)
    }

    static func - (lhs: Point, rhs: HorizontalVector) -> Point {
        .init(x: lhs.x - rhs.dx, y: lhs.y)
    }
}
