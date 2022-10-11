//
//  TextFieldNextable.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 11.10.2022.
//

import UIKit

enum TextFieldOrAction {
    case nextTextField(UITextField)
    case action( (() -> ())? )
}

protocol TextFieldNextable: UIViewController {
    func nextFieldOrActoin(for textField: UITextField) -> TextFieldOrAction
}

extension TextFieldNextable {
    func nextFieldOrActoin(for textField: UITextField) -> TextFieldOrAction {
        let textFields: [UITextField] = self.view.subviews.compactMap({$0 as? UITextField})
        guard let index = textFields.firstIndex(of: textField),
              (index + 1) < textFields.count
        else {
            return TextFieldOrAction.action(nil)
        }
        
        let nextTextField = textFields[index + 1]
        
        return TextFieldOrAction.nextTextField(nextTextField)
    }
}
