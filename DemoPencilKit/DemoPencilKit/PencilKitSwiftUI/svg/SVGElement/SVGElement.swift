//
//  Created by Kurlovich Vitali on 8/3/26.
//

public protocol SVGElement: Sendable {
    static var name: String { get }

    var attributes: [String: String] { get }
    var childs: [any SVGElement] { get }
}

public extension SVGElement {
    var name: String {
        Self.name
    }
}

public protocol SVGMutableElement: SVGElement {
    var attributes: [String: String] { get set }
    var childs: [any SVGElement] { get set }
}
