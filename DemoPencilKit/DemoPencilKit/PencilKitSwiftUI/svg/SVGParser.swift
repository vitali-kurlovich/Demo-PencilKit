//
//  SVGParser.swift
//  DemoPencilKit
//
//  Created by Kurlovich Vitali on 8/1/26.
//

import Foundation
import OSLog
import Playgrounds

class SVGParser: NSObject {
    private var root: SvgTag?
    private var stack: [any SVGMutableElement] = []

    func parse(data: Data) -> SvgTag? {
        let parser = XMLParser(data: data)
        parser.delegate = self

        parser.parse()

        return root
    }
}

extension SVGParser {
    private func format(data: Data) -> String {
        "[\(data.map { String($0, radix: 16) }.joined(separator: ","))]"
    }
}

extension SVGParser: XMLParserDelegate {
    func parserDidStartDocument(_: XMLParser) {
        debugPrint(#function)
        stack.removeAll(keepingCapacity: true)
        root = nil
    }

    func parserDidEndDocument(_: XMLParser) {
        debugPrint(#function)
        assert(stack.isEmpty)
    }

    /**
     func parser(_: XMLParser, foundNotationDeclarationWithName name: String, publicID: String?, systemID: String?) {
         debugPrint("\(#function) name:\(name), publicID: \(publicID ?? "nil"), systemID: \(systemID ?? "nil")")
     }
     */
    func parser(_: XMLParser, foundUnparsedEntityDeclarationWithName name: String, publicID: String?, systemID: String?, notationName: String?) {
        debugPrint("\(#function) name:\(name), publicID: \(publicID ?? "nil"), systemID: \(systemID ?? "nil"), notationName: \(notationName ?? "nil")")
    }

    func parser(_: XMLParser, foundAttributeDeclarationWithName attributeName: String, forElement elementName: String, type: String?, defaultValue: String?) {
        debugPrint("\(#function) attributeName:\(attributeName), elementName: \(elementName), type: \(type ?? "nil"), defaultValue: \(defaultValue ?? "nil")")
    }

    func parser(_: XMLParser, foundElementDeclarationWithName elementName: String, model: String) {
        debugPrint("\(#function) elementName:\(elementName), model: \(model)")
    }

    func parser(_: XMLParser, foundInternalEntityDeclarationWithName name: String, value: String?) {
        debugPrint("\(#function) name:\(name), value: \(value ?? "nil")")
    }

    func parser(_: XMLParser, foundExternalEntityDeclarationWithName name: String, publicID: String?, systemID: String?) {
        debugPrint("\(#function) name:\(name), publicID: \(publicID ?? "nil"), systemID: \(systemID ?? "nil")")
    }

    func parser(_: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        debugPrint("\(#function) didStartElement:\(elementName), namespaceURI: \(namespaceURI ?? "nil"), qualifiedName: \(qName ?? "nil"), attributes: \(attributeDict)")

        switch elementName {
        case SvgTag.name:
            let root = SvgTag(attributes: attributeDict)
            // self.root = root
            stack.append(root)

        case GTag.name:
            let g = GTag(attributes: attributeDict)
            stack.append(g)

        case PathTag.name:
            let path = PathTag(attributes: attributeDict)
            stack.append(path)

        default:
            break
        }
    }

    func parser(_: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        debugPrint("\(#function) didEndElement:\(elementName), namespaceURI: \(namespaceURI ?? "nil"), qualifiedName: \(qName ?? "nil")")

        switch elementName {
        case SvgTag.name:
            guard var root = stack.popLast() else {
                assertionFailure()
                return
            }

            assert(root is SvgTag)
            self.root = (root as! SvgTag)

        case GTag.name:
            guard var g = stack.popLast() else {
                assertionFailure()
                return
            }

            assert(g is GTag)

            guard var parent = stack.popLast() else {
                assertionFailure()
                return
            }
            parent.childs.append(g)

            stack.append(parent)

        case PathTag.name:
            guard let path = stack.popLast() else {
                assertionFailure()
                return
            }

            assert(path is PathTag)

            guard var parent = stack.popLast() else {
                assertionFailure()
                return
            }
            parent.childs.append(path)

            stack.append(parent)

        default:
            break
        }
    }
    /*
     func parser(_: XMLParser, didStartMappingPrefix prefix: String, toURI namespaceURI: String) {
         debugPrint("\(#function) didStartMappingPrefix:\(prefix), toURI: \(namespaceURI)")
     }

     func parser(_: XMLParser, didEndMappingPrefix prefix: String) {
         debugPrint("\(#function) didEndMappingPrefix:\(prefix)")
     }

     func parser(_: XMLParser, foundCharacters string: String) {
         debugPrint("\(#function) foundCharacters:\(string)")
     }

     func parser(_: XMLParser, foundIgnorableWhitespace whitespaceString: String) {
         debugPrint("\(#function) whitespaceString:\(whitespaceString)")
     }

     func parser(_: XMLParser, foundProcessingInstructionWithTarget target: String, data: String?) {
         debugPrint("\(#function) foundProcessingInstructionWithTarget:\(target), data:\(data ?? "nil")")
     }

     func parser(_: XMLParser, foundComment comment: String) {
         debugPrint("\(#function) foundComment:\(comment)")
     }

     func parser(_: XMLParser, foundCDATA CDATABlock: Data) {
         debugPrint("\(#function) foundCDATA:\(self.format(data: CDATABlock))")
     }

     func parser(_: XMLParser, parseErrorOccurred parseError: any Error) {
         debugPrint(
             "\(#function) parseErrorOccurred:\(parseError.localizedDescription)",
         )
     }

     func parser(_: XMLParser, validationErrorOccurred validationError: any Error) {
         debugPrint(
             "\(#function) validationErrorOccurred:\(validationError.localizedDescription)",
         )
     }
     */
}

// SVGElement+transform

#Playground {
    let string = "1,0,0,1,102,207"

    var iterator = SplitIterator(string: string, separator: ",")

    var str = iterator.next()
    str = iterator.next()
    str = iterator.next()
    str = iterator.next()
    str = iterator.next()
    str = iterator.next()
    str = iterator.next()
}
