//
//  Created by Kurlovich Vitali on 8/3/26.
//

public struct GTag: SVGMutableElement {
    public static var name: String {
        "g"
    }

    public var attributes: [String: String] = [:]
    public var childs: [any SVGElement] = []

    init(attributes: [String: String] = [:], childs: [any SVGElement] = []) {
        self.attributes = attributes
        self.childs = childs
    }
}
