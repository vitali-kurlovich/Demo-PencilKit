//
//  Created by Kurlovich Vitali on 8/4/26.
//

public struct HorizontalPoint: Sendable, Hashable {
    public var x: Double

    @inlinable
    public init(x: Double) {
        self.x = x
    }
}

public struct HorizontalVector: Sendable, Hashable {
    public var dx: Double

    @inlinable
    public init(dx: Double) {
        self.dx = dx
    }
}

public extension HorizontalPoint {
    @inlinable
    static func + (lhs: HorizontalPoint, rhs: HorizontalVector) -> HorizontalPoint {
        .init(x: lhs.x + rhs.dx)
    }

    @inlinable
    static func - (lhs: HorizontalPoint, rhs: HorizontalVector) -> HorizontalPoint {
        .init(x: lhs.x - rhs.dx)
    }
}

public extension HorizontalPoint {
    @inlinable
    static func - (lhs: HorizontalPoint, rhs: HorizontalPoint) -> HorizontalVector {
        .init(dx: lhs.x - rhs.x)
    }
}

public extension Point {
    @inlinable
    static func + (lhs: Point, rhs: HorizontalVector) -> Point {
        .init(x: lhs.x + rhs.dx, y: lhs.y)
    }

    @inlinable
    static func - (lhs: Point, rhs: HorizontalVector) -> Point {
        .init(x: lhs.x - rhs.dx, y: lhs.y)
    }
}
