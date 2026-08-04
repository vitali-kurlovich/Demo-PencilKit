//
//  Created by Kurlovich Vitali on 8/4/26.
//

struct VerticalPoint: Sendable, Hashable {
    var y: Double
}

struct VerticalVector: Sendable, Hashable {
    var dy: Double
}

extension VerticalPoint {
    static func + (lhs: VerticalPoint, rhs: VerticalVector) -> VerticalPoint {
        .init(y: lhs.y + rhs.dy)
    }

    static func - (lhs: VerticalPoint, rhs: VerticalVector) -> VerticalPoint {
        .init(y: lhs.y - rhs.dy)
    }
}

extension VerticalPoint {
    static func - (lhs: VerticalPoint, rhs: VerticalPoint) -> VerticalVector {
        .init(dy: lhs.y - rhs.y)
    }
}

extension Point {
    static func + (lhs: Point, rhs: VerticalVector) -> Point {
        .init(x: lhs.x, y: lhs.y + rhs.dy)
    }

    static func - (lhs: Point, rhs: VerticalVector) -> Point {
        .init(x: lhs.x, y: lhs.y - rhs.dy)
    }
}
