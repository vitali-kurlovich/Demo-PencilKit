//
//  Created by Kurlovich Vitali on 8/3/26.
//

import struct Foundation.CharacterSet
import Playgrounds
import RegexBuilder

struct PathTag: SVGMutableElement {
    static var name: String {
        "path"
    }

    var attributes: [String: String] = [:]
    var childs: [any SVGElement] = []

    init(attributes: [String: String] = [:], childs: [any SVGElement] = []) {
        self.attributes = attributes
        self.childs = childs
    }
}

extension PathTag {
    var commands: SVGPathCommands<String> {
        SVGPathCommands(attributes["d"] ?? "")
    }
}
