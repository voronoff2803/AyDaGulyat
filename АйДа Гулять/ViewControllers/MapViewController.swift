//
//  MapViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 23.10.2022.
//

import UIKit
import Jelly

class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    var animator: Animator?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let presentedVC = ProfileViewController()
        
        
        let uiConfiguration = PresentationUIConfiguration(backgroundStyle: .dimmed(alpha: 0.7), isTapBackgroundToDismissEnabled: true)
        let interaction = InteractionConfiguration(presentingViewController: self, completionThreshold: 0.3, dragMode: .canvas)
        let presentation = SlidePresentation(uiConfiguration: uiConfiguration, direction: .bottom, parallax: 0.05, interactionConfiguration: interaction)
        
        animator = Animator(presentation: presentation)
        animator?.prepare(presentedViewController: presentedVC)
        
        
        present(presentedVC, animated: true)
    }
    
    
    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
    }
}
