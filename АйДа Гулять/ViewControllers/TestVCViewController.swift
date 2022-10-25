//
//  TestVCViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 24.10.2022.
//

import UIKit

class TestVCViewController: UIViewController {
    
    let pageView = UIView().then {
        $0.backgroundColor = .red
    }
    
    let pageControlView = UIPageControl().then {
        $0.numberOfPages = 10
        $0.pageIndicatorTintColor = .appColor(.grayEmpty)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .appColor(.backgroundFirst)

        [pageView, pageControlView].forEach({self.view.addSubview($0)})
        
        pageControlView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.centerX.equalToSuperview()
        }
        
        pageView.snp.makeConstraints { make in
            make.top.equalTo(pageControlView).offset(40)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
