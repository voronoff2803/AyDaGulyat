//
//  DynamicTableView.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 24.12.2022.
//

import UIKit

class DynamicTableView: UITableView {

    var isDynamicSizeRequired = false
    
    override func layoutSubviews() {
      super.layoutSubviews()
      if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
        
        if self.intrinsicContentSize.height > frame.size.height {
          self.invalidateIntrinsicContentSize()
        }
        if isDynamicSizeRequired {
          self.invalidateIntrinsicContentSize()
        }
      }
    }
    
    override var intrinsicContentSize: CGSize {
      return contentSize
    }
}
