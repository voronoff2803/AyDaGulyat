//
//  ScalableImageView.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 11.10.2022.
//

import UIKit

class ScalableImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
}
