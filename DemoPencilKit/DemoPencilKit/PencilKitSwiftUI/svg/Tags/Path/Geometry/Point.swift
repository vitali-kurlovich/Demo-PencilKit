//
//  Created by Kurlovich Vitali on 8/4/26.
//

public struct Point: Sendable, Hashable {
    public var x: Double
    public var y: Double

    @inlinable
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

extension Point: AdditiveArithmetic {
    @inlinable
    public static var zero: Point {
        .init(x: 0, y: 0)
    }

    @inlinable
    public static func + (lhs: Point, rhs: Point) -> Point {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    @inlinable
    public static func - (lhs: Point, rhs: Point) -> Point {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    @inlinable
    public static func += (left: inout Point, right: Point) {
        left.x += right.x
        left.y += right.y
    }

    @inlinable
    public static func -= (left: inout Point, right: Point) {
        left.x -= right.x
        left.y -= right.y
    }
}
