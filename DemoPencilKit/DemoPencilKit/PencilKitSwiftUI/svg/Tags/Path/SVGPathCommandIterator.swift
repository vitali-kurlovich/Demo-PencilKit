//
//  Created by Kurlovich Vitali on 8/4/26.
//

import struct Foundation.CharacterSet

struct SVGPathCommandIterator<S: StringProtocol>: IteratorProtocol {
    typealias Element = SVGPathCommand

    private var iterator: CommandIterator<S>

    init(_ string: S) {
        iterator = CommandIterator(string)
    }

    mutating func next() -> SVGPathCommand? {
        guard let next = iterator.next() else {
            return nil
        }

        let count = next.arguments.count / next.command.argsCount

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
            var offset: [HorizontalVector] = []

            offset.reserveCapacity(count)
            var iterator = next.arguments.makeIterator()

            while let dx = iterator.next() {
                offset.append(HorizontalVector(dx: dx))
            }

            return .horizontalRelative(
                HorizontalRelativeLineCommand(offset: offset),
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
            var offset: [VerticalVector] = []

            offset.reserveCapacity(count)
            var iterator = next.arguments.makeIterator()

            while let dy = iterator.next() {
                offset.append(VerticalVector(dy: dy))
            }

            return .verticalRelative(VerticalRelativeLineCommand(offset: offset))

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

private extension CharacterSet {
    static let decimalDigitsAndFractionSeparator = CharacterSet.decimalDigits.union(
        CharacterSet(charactersIn: "."),
    )

    static let whitespacesNewlinesAndCommma = CharacterSet.whitespacesAndNewlines.union(
        CharacterSet(charactersIn: ","),
    )
}

private struct CommandIterator<S: StringProtocol>: IteratorProtocol {
    let string: S

    var startIndex: S.Index

    var isFinish = false

    init(_ string: S) {
        self.string = string
        startIndex = string.startIndex
    }

    var isEnd: Bool {
        startIndex == string.endIndex
    }

    mutating func next() -> PathElement? {
        if isFinish {
            return nil
        }

        let char = string[startIndex]

        guard let command = Command(rawValue: char) else {
            return nil
        }

        if isEnd == false {
            startIndex = string.index(after: startIndex)
        } else {
            isFinish = true
        }

        return PathElement(
            command: command,
            arguments: argsuments(for: command),
        )
    }

    mutating func argsuments(for command: Command) -> [Double] {
        if command == .z || command == .Z {
            return []
        }

        var argsuments: [Double] = []

        let count = command.argsCount

        while true {
            skipWhitespacesAndNewlines()

            argsuments.reserveCapacity(count)

            for _ in 0 ..< count {
                argsuments.append(nextNumber())
            }

            skipWhitespacesAndNewlines()

            let char = string[startIndex]
            let command = Command(rawValue: char)

            if command != nil || isEnd {
                break
            }
        }

        return argsuments
    }

    mutating func nextNumber() -> Double {
        skipWhitespacesAndNewlines()

        var begin = startIndex

        while CharacterSet.decimalDigitsAndFractionSeparator.contains(string[startIndex].unicodeScalars.first!) {
            if isEnd {
                isFinish = true
                break
            }
            startIndex = string.index(after: startIndex)
        }

        let end = startIndex

        debugPrint(string[begin ..< end])

        return Double(string[begin ..< end])!
    }

    mutating func skipWhitespacesAndNewlines() {
        while CharacterSet.decimalDigitsAndFractionSeparator.contains(string[startIndex].unicodeScalars.first!) {
            if isEnd {
                isFinish = true
                break
            }
            startIndex = string.index(after: startIndex)
        }
    }
}

extension CommandIterator {
    struct PathElement {
        let command: Command
        let arguments: [Double]
    }

    enum Command: Character {
        case M = "M"
        case m = "m"

        case L = "L"
        case l = "l"

        case H = "H"
        case h = "h"

        case v = "v"
        case V = "V"

        case C = "C"
        case c = "c"

        case S = "S"
        case s = "s"

        case Q = "Q"
        case q = "q"

        case T = "T"
        case t = "t"

        case A = "A"
        case a = "a"

        case Z = "Z"
        case z = "z"

        var argsCount: Int {
            switch self {
            case .Z, .z:
                0
            case .H, .h, .V, .v:
                1
            case .M, .m, .L, .l, .T, .t:
                2
            case .S, .s, .Q, .q:
                4
            case .C, .c:
                6
            case .A, .a:
                7
            }
        }
    }
}
