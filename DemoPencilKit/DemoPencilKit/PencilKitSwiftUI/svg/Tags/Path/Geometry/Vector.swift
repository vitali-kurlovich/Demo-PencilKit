//
//  Created by Kurlovich Vitali on 8/4/26.
//

struct Vector: Sendable, Hashable {
    var dx: Double
    var dy: Double
}

extension Vector: AdditiveArithmetic {
    static var zero: Vector {
        .init(dx: 0, dy: 0)
    }

    static func + (lhs: Vector, rhs: Vector) -> Vector {
        .init(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    static func - (lhs: Vector, rhs: Vector) -> Vector {
        .init(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }
}

extension Point {
    static func + (lhs: Point, rhs: Vector) -> Point {
        .init(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }

    static func - (lhs: Point, rhs: Vector) -> Point {
        .init(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
    }
}

extension Point {
    static func - (lhs: Point, rhs: Point) -> Vector {
        .init(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
    }
}
