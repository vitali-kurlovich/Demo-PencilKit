//
//  Created by Kurlovich Vitali on 8/4/26.
//

import struct Foundation.CharacterSet

public struct SVGPathCommandIterator<S: StringProtocol>: IteratorProtocol {
    public typealias Element = SVGPathCommand

    private var iterator: CommandIterator<S>

    init(_ string: S) {
        iterator = CommandIterator(string)
    }

    public mutating func next() -> SVGPathCommand? {
        guard let next = iterator.next() else {
            return nil
        }

        let argsCount = next.command.argsCount
        let count = argsCount > 0 ? next.arguments.count / argsCount : 0

        switch next.command {
        case .M:
            var points: [Point] = []
            points.reserveCapacity(count)
            var iterator = next.arguments.makeIterator()

            while let x = iterator.next(), let y = iterator.next() {
                points.append(Point(x: x, y: y))
            }

            return .move(MoveCommand(points: points))

        case .m:
            var offsets: [Vector] = []
            offsets.reserveCapacity(count)
            var iterator = next.arguments.makeIterator()

            while let dx = iterator.next(), let dy = iterator.next() {
                offsets.append(Vector(dx: dx, dy: dy))
            }

            return .moveRelative(MoveRelativeCommand(offsets: offsets))

        case .L:
            var points: [Point] = []

            points.reserveCapacity(count)
            var iterator = next.arguments.makeIterator()

            while let x = iterator.next(), let y = iterator.next() {
                points.append(Point(x: x, y: y))
            }

            return .line(LineCommand(points: points))

        case .l:
            var offsets: [Vector] = []
            offsets.reserveCapacity(count)
            var iterator = next.arguments.makeIterator()

            while let dx = iterator.next(), let dy = iterator.next() {
                offsets.append(Vector(dx: dx, dy: dy))
            }

            return .lineRelative(LineRelativeCommand(offsets: offsets))

        case .H:
            var points: [HorizontalPoint] = []

            points.reserveCapacity(count)
            var iterator = next.arguments.makeIterator()

            while let x = iterator.next() {
                points.append(HorizontalPoint(x: x))
            }

            return .horizontal(HorizontalLineCommand(points: points))

        case .h:
            var offsets: [HorizontalVector] = []

            offsets.reserveCapacity(count)
            var iterator = next.arguments.makeIterator()

            while let dx = iterator.next() {
                offsets.append(HorizontalVector(dx: dx))
            }

            return .horizontalRelative(
                HorizontalRelativeLineCommand(offsets: offsets),
            )

        case .V:
            var points: [VerticalPoint] = []

            points.reserveCapacity(count)
            var iterator = next.arguments.makeIterator()

            while let y = iterator.next() {
                points.append(VerticalPoint(y: y))
            }

            return .vertical(VerticalLineCommand(points: points))

        case .v:
            var offsets: [VerticalVector] = []

            offsets.reserveCapacity(count)
            var iterator = next.arguments.makeIterator()

            while let dy = iterator.next() {
                offsets.append(VerticalVector(dy: dy))
            }

            return .verticalRelative(VerticalRelativeLineCommand(offsets: offsets))

        case .C:
            var points: [CubicPoint] = []
            points.reserveCapacity(count)

            var iterator = next.arguments.makeIterator()

            while let x1 = iterator.next(), let y1 = iterator.next(),
                  let x2 = iterator.next(), let y2 = iterator.next(),
                  let x = iterator.next(), let y = iterator.next()
            {
                let p1 = Point(x: x1, y: y1)
                let p2 = Point(x: x2, y: y2)
                let p = Point(x: x, y: y)

                points.append(CubicPoint(p1: p1, p2: p2, p: p))
            }

            return .cubic(CubicCommand(points: points))

        case .c:
            var offsets: [CubicVector] = []
            offsets.reserveCapacity(count)

            var iterator = next.arguments.makeIterator()

            while let dx1 = iterator.next(), let dy1 = iterator.next(),
                  let dx2 = iterator.next(), let dy2 = iterator.next(),
                  let dx = iterator.next(), let dy = iterator.next()
            {
                let v1 = Vector(dx: dx1, dy: dy1)
                let v2 = Vector(dx: dx2, dy: dy2)
                let v = Vector(dx: dx, dy: dy)

                offsets.append(CubicVector(v1: v1, v2: v2, v: v))
            }

            return .cubicRelative(CubicRelativeCommand(offsets: offsets))

        case .S:
            var points: [SmoothPoint] = []
            points.reserveCapacity(count)

            var iterator = next.arguments.makeIterator()

            while let x2 = iterator.next(), let y2 = iterator.next(),
                  let x = iterator.next(), let y = iterator.next()
            {
                let p2 = Point(x: x2, y: y2)
                let p = Point(x: x, y: y)

                points.append(SmoothPoint(p2: p2, p: p))
            }

            return .smooth(SmoothCommand(points: points))

        case .s:
            var offsets: [SmoothVector] = []
            offsets.reserveCapacity(count)

            var iterator = next.arguments.makeIterator()

            while let dx2 = iterator.next(), let dy2 = iterator.next(),
                  let dx = iterator.next(), let dy = iterator.next()
            {
                let v2 = Vector(dx: dx2, dy: dy2)
                let v = Vector(dx: dx, dy: dy)

                offsets.append(SmoothVector(v2: v2, v: v))
            }

            return .smoothRelative(SmoothRelativeCommand(offsets: offsets))

        case .Q:
            var points: [QuadraticPoint] = []
            points.reserveCapacity(count)

            var iterator = next.arguments.makeIterator()

            while let x1 = iterator.next(), let y1 = iterator.next(),
                  let x = iterator.next(), let y = iterator.next()
            {
                let p1 = Point(x: x1, y: y1)
                let p = Point(x: x, y: y)

                points.append(QuadraticPoint(p1: p1, p: p))
            }

            return .quadratic(QuadraticCommand(points: points))

        case .q:
            var offsets: [QuadraticVector] = []
            offsets.reserveCapacity(count)

            var iterator = next.arguments.makeIterator()

            while let dx1 = iterator.next(), let dy1 = iterator.next(),
                  let dx = iterator.next(), let dy = iterator.next()
            {
                let v1 = Vector(dx: dx1, dy: dy1)
                let v = Vector(dx: dx, dy: dy)

                offsets.append(QuadraticVector(v1: v1, v: v))
            }

            return .quadraticRelative(QuadraticRelativeCommand(offsets: offsets))

        case .T:
            var points: [Point] = []
            points.reserveCapacity(count)

            var iterator = next.arguments.makeIterator()

            while let x = iterator.next(), let y = iterator.next() {
                points.append(Point(x: x, y: y))
            }

            return .smoothQuadratic(SmoothQuadraticCommand(points: points))

        case .t:
            var offsets: [Vector] = []
            offsets.reserveCapacity(count)

            var iterator = next.arguments.makeIterator()

            while let dx = iterator.next(), let dy = iterator.next() {
                offsets.append(Vector(dx: dx, dy: dy))
            }

            return .smoothQuadraticRelative(
                SmoothQuadraticRelativeCommand(offsets: offsets),
            )

        case .A, .a:
            return self.next()

        case .Z, .z:
            return .closePath
        }
    }
}
