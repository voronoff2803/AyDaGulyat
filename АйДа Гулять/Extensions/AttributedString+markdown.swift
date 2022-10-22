//
//  AttributedString+markdown.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 19.10.2022.
//

import Foundation
import MarkdownKit


extension NSAttributedString {
    static func fromMarkdown(source: String) -> NSAttributedString {
        let parser = MarkdownParser(font: .montserratRegular(size: 15), color: .appColor(.black))
        return parser.parse(source)
    }
}
