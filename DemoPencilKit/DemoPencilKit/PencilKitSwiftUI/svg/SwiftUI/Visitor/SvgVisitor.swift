//
//  Created by Kurlovich Vitali on 8/5/26.
//

import struct SwiftUI.GraphicsContext

public protocol SvgVisitor {
    var context: GraphicsContext { get }

    func visit(with context: inout GraphicsContext, document: SvgDocument)

    func visit(with context: inout GraphicsContext, tag: SvgTag)
    func visit(with context: inout GraphicsContext, tag: GTag)
    func visit(with context: inout GraphicsContext, tag: PathTag)
}

public extension SvgVisitor {
    func visit(with _: inout GraphicsContext, document _: SvgDocument) {}

    func visit(with _: inout GraphicsContext, tag _: SvgTag) {}
    func visit(with _: inout GraphicsContext, tag _: GTag) {}
    func visit(with _: inout GraphicsContext, tag _: PathTag) {}
}
