//
//  Created by Kurlovich Vitali on 8/3/26.
//

public struct SvgTag: SVGMutableElement, Sendable {
    public static var name: String {
        "svg"
    }

    public var attributes: [String: String] = [:]
    public var childs: [any SVGElement] = []

    init(attributes: [String: String] = [:], childs: [any SVGElement] = []) {
        self.attributes = attributes
        self.childs = childs
    }
}

public extension SvgTag {
    var version: String? {
        attributes["version"]
    }
}
