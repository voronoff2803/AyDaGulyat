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
        let textFields: [UITextField] = self.getAllTextFields(fromView: self.view)
        guard let index = textFields.firstIndex(of: textField),
              (index + 1) < textFields.count
        else {
            return TextFieldOrAction.action(nil)
        }
        
        let nextTextField = textFields[index + 1]
        
        return TextFieldOrAction.nextTextField(nextTextField)
    }
    
    private func getAllTextFields(fromView view: UIView)-> [UITextField] {
        return view.subviews.flatMap { (view) -> [UITextField] in
            if view is UITextField {
                return [(view as! UITextField)]
            } else {
                return getAllTextFields(fromView: view)
            }
        }.compactMap({$0})
    }
}
