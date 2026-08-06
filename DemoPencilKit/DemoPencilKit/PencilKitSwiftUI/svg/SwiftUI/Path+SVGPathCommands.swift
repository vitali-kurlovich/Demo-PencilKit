//
//  Created by Kurlovich Vitali on 8/5/26.
//

import struct SwiftUI.Path

public extension Path {
    init(path: String) {
        self.init(SVGPathCommands(path))
    }

    init(_ commands: SVGPathCommands) {
        self.init()
        apply(commands)
    }
}

private extension Path {
    mutating func apply(_ commands: SVGPathCommands) {
        var last: Point = .zero

        for command in commands {
            apply(&last, command)
        }
    }

    mutating func apply(_ last: inout Point, _ command: SVGPathCommand) {
        switch command {
        case let .move(cmd):
            apply(&last, cmd)
        case let .moveRelative(cmd):
            apply(&last, cmd)
        case let .line(cmd):
            apply(&last, cmd)
        case let .lineRelative(cmd):
            apply(&last, cmd)
        case let .horizontal(cmd):
            apply(&last, cmd)
        case let .horizontalRelative(cmd):
            apply(&last, cmd)
        case let .vertical(cmd):
            apply(&last, cmd)
        case let .verticalRelative(cmd):
            apply(&last, cmd)
        case let .cubic(cmd):
            apply(&last, cmd)
        case let .cubicRelative(cmd):
            apply(&last, cmd)
        case let .smooth(cmd):
            apply(&last, cmd)
        case let .smoothRelative(cmd):
            apply(&last, cmd)
        case let .quadratic(cmd):
            apply(&last, cmd)
        case let .quadraticRelative(cmd):
            apply(&last, cmd)
        case let .smoothQuadratic(cmd):
            apply(&last, cmd)
        case let .smoothQuadraticRelative(cmd):
            apply(&last, cmd)
        case .closePath:
            closeSubpath()
        }
    }
}

/// - Move
extension Path {
    mutating func apply(_ last: inout Point, _ command: MoveCommand) {
        for point in command.points {
            last = point

            move(to: .init(last))
        }
    }

    mutating func apply(_ last: inout Point, _ command: MoveRelativeCommand) {
        for offset in command.offsets {
            last += offset

            move(to: .init(last))
        }
    }
}

/// - Line
extension Path {
    mutating func apply(_ last: inout Point, _ command: LineCommand) {
        for point in command.points {
            last = point

            addLine(to: .init(last))
        }
    }

    mutating func apply(_ last: inout Point, _ command: LineRelativeCommand) {
        for offset in command.offsets {
            last += offset

            addLine(to: .init(last))
        }
    }

    mutating func apply(_ last: inout Point, _ command: HorizontalLineCommand) {
        for point in command.points {
            last.x = point.x

            addLine(to: .init(last))
        }
    }

    mutating func apply(
        _ last: inout Point,
        _ command: HorizontalRelativeLineCommand,
    ) {
        for offset in command.offsets {
            last.x += offset.dx

            addLine(to: .init(last))
        }
    }

    mutating func apply(_ last: inout Point, _ command: VerticalLineCommand) {
        for point in command.points {
            last.y = point.y

            addLine(to: .init(last))
        }
    }

    mutating func apply(
        _ last: inout Point,
        _ command: VerticalRelativeLineCommand,
    ) {
        for offset in command.offsets {
            last.y += offset.dy

            addLine(to: .init(last))
        }
    }
}

/// - Curve
extension Path {
    mutating func apply(_ last: inout Point, _ command: CubicCommand) {
        for point in command.points {
            last = point.p

            let p = last
            let p1 = point.p1
            let p2 = point.p2

            addCurve(to: .init(p), control1: .init(p1), control2: .init(p2))
        }
    }

    mutating func apply(_ last: inout Point, _ command: CubicRelativeCommand) {
        for offset in command.offsets {
            last += offset.v

            let p = last
            let p1 = p + offset.v1
            let p2 = p + offset.v2

            addCurve(to: .init(p), control1: .init(p1), control2: .init(p2))
        }
    }

    mutating func apply(_ last: inout Point, _ command: SmoothCommand) {
        for point in command.points {
            last = point.p

            let p = last
            let p2 = point.p2

            let v1: Vector = p2 - p

            let p1 = p + v1

            addCurve(to: .init(p), control1: .init(p1), control2: .init(p2))
        }
    }

    mutating func apply(_ last: inout Point, _ command: SmoothRelativeCommand) {
        for offset in command.offsets {
            last += offset.v

            let p = last

            let p2 = p + offset.v2

            let v1: Vector = p2 - p

            let p1 = p + v1

            addCurve(to: .init(p), control1: .init(p1), control2: .init(p2))
        }
    }

    mutating func apply(_ last: inout Point, _ command: QuadraticCommand) {
        for point in command.points {
            last = point.p

            let p = last
            let p1 = point.p1

            addQuadCurve(to: .init(p), control: .init(p1))
        }
    }

    mutating func apply(_ last: inout Point, _ command: QuadraticRelativeCommand) {
        for offset in command.offsets {
            last += offset.v

            let p = last

            let p1 = p + offset.v1

            addQuadCurve(to: .init(p), control: .init(p1))
        }
    }

    // TODO: Fix control point
    mutating func apply(_ last: inout Point, _ command: SmoothQuadraticCommand) {
        for point in command.points {
            last = point

            let p = last
            let p1 = p

            addQuadCurve(to: .init(p), control: .init(p1))
        }
    }

    // TODO: Fix control point
    mutating func apply(_ last: inout Point, _ command: SmoothQuadraticRelativeCommand) {
        for offset in command.offsets {
            last += offset

            let p = last
            let p1 = p

            addQuadCurve(to: .init(p), control: .init(p1))
        }
    }
}
