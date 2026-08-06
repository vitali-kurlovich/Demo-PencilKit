//
//  Created by Kurlovich Vitali on 8/5/26.
//

import struct SwiftUI.GraphicsContext

public struct SvgDocumentVisitor<V: SvgVisitor> {
    public let document: SvgDocument
    public let visitor: V

    public init(visitor: V, document: SvgDocument) {
        self.document = document
        self.visitor = visitor
    }

    public func visit() {
        var context = visitor.context

        visitor.visit(with: &context, document: document)

        visit(with: context, tag: document.svg)
    }
}

extension SvgDocumentVisitor {
    func visit(with context: GraphicsContext, tag: any SVGElement) {
        if let tag = tag as? GTag {
            visit(with: context, tag: tag)
        }

        if let tag = tag as? PathTag {
            visit(with: context, tag: tag)
        }

        if let tag = tag as? SvgTag {
            visit(with: context, tag: tag)
        }
    }

    func visit(with context: GraphicsContext, tag: SvgTag) {
        var context = context

        if let transform = tag.transform {
            context.transform = context.transform.concatenating(transform)
        }

        visitor.visit(with: &context, tag: tag)

        for child in tag.childs {
            visit(with: context, tag: child)
        }
    }

    func visit(with context: GraphicsContext, tag: GTag) {
        var context = context

        if let transform = tag.transform {
            context.transform = context.transform.concatenating(transform)
        }

        visitor.visit(with: &context, tag: tag)

        for child in tag.childs {
            visit(with: context, tag: child)
        }
    }

    func visit(with context: GraphicsContext, tag: PathTag) {
        var context = context

        if let transform = tag.transform {
            context.transform = context.transform.concatenating(transform)
        }

        visitor.visit(with: &context, tag: tag)

        for child in tag.childs {
            visit(with: context, tag: child)
        }
    }
}
