//
//  Created by Kurlovich Vitali on 8/3/26.
//

public struct PathTag: SVGMutableElement {
    public static var name: String {
        "path"
    }

    public var attributes: [String: String] = [:]
    public var childs: [any SVGElement] = []

    init(attributes: [String: String] = [:], childs: [any SVGElement] = []) {
        self.attributes = attributes
        self.childs = childs
    }
}

public extension PathTag {
    var commands: SVGPathCommands {
        SVGPathCommands(attributes["d"] ?? "")
    }
}
