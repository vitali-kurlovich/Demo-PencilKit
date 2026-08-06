//
//  Created by Kurlovich Vitali on 8/4/26.
//

public struct Vector: Sendable, Hashable {
    public var dx: Double
    public var dy: Double

    @inlinable
    public init(dx: Double, dy: Double) {
        self.dx = dx
        self.dy = dy
    }
}

extension Vector: AdditiveArithmetic {
    @inlinable
    public static var zero: Vector {
        .init(dx: 0, dy: 0)
    }

    @inlinable
    public static func + (lhs: Vector, rhs: Vector) -> Vector {
        .init(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    @inlinable
    public static func - (lhs: Vector, rhs: Vector) -> Vector {
        .init(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }

    @inlinable
    public static func += (left: inout Vector, right: Vector) {
        left = left + right
    }

    @inlinable
    public static func -= (left: inout Vector, right: Vector) {
        left = left - right
    }
}

public extension Point {
    @inlinable
    static func + (lhs: Point, rhs: Vector) -> Point {
        .init(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
    }

    @inlinable
    static func - (lhs: Point, rhs: Vector) -> Point {
        .init(x: lhs.x - rhs.dx, y: lhs.y - rhs.dy)
    }

    @inlinable
    static func += (left: inout Point, right: Vector) {
        left.x += right.dx
        left.y += right.dy
    }

    @inlinable
    static func -= (left: inout Point, right: Vector) {
        left.x -= right.dx
        left.y -= right.dy
    }
}

public extension Point {
    @inlinable
    static func - (lhs: Point, rhs: Point) -> Vector {
        .init(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
    }
}
