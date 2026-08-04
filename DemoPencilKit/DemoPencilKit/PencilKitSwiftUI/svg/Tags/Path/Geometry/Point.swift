//
//  Created by Kurlovich Vitali on 8/4/26.
//

struct Point: Sendable, Hashable {
    var x: Double
    var y: Double
}

extension Point: AdditiveArithmetic {
    static var zero: Point {
        .init(x: 0, y: 0)
    }

    static func + (lhs: Point, rhs: Point) -> Point {
        .init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func - (lhs: Point, rhs: Point) -> Point {
        .init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
