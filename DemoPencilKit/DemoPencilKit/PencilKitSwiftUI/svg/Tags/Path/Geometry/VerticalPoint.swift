//
//  Created by Kurlovich Vitali on 8/4/26.
//

public struct VerticalPoint: Sendable, Hashable {
    public var y: Double

    @inlinable
    public init(y: Double) {
        self.y = y
    }
}

public struct VerticalVector: Sendable, Hashable {
    public var dy: Double

    @inlinable
    public init(dy: Double) {
        self.dy = dy
    }
}

public extension VerticalPoint {
    @inlinable
    static func + (lhs: VerticalPoint, rhs: VerticalVector) -> VerticalPoint {
        .init(y: lhs.y + rhs.dy)
    }

    @inlinable
    static func - (lhs: VerticalPoint, rhs: VerticalVector) -> VerticalPoint {
        .init(y: lhs.y - rhs.dy)
    }
}

public extension VerticalPoint {
    @inlinable
    static func - (lhs: VerticalPoint, rhs: VerticalPoint) -> VerticalVector {
        .init(dy: lhs.y - rhs.y)
    }
}

public extension Point {
    @inlinable
    static func + (lhs: Point, rhs: VerticalVector) -> Point {
        .init(x: lhs.x, y: lhs.y + rhs.dy)
    }

    @inlinable
    static func - (lhs: Point, rhs: VerticalVector) -> Point {
        .init(x: lhs.x, y: lhs.y - rhs.dy)
    }
}
