//
//  ReaderViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 27.12.2022.
//

import UIKit
import MarkdownView

let mdstring = """
You will like those projects!

---

# h1 Heading 8-)
## h2 Heading
### h3 Heading
#### h4 Heading
##### h5 Heading
###### h6 Heading
"""

class ReaderViewController: UIViewController {
    //let viewModel: WalkViewModel
    
    
    
    let css = [
          "h1 { color:red; }",
          "h2 { color:green; }",
          "h3 { color:blue; }",
    ].joined(separator: "\n")
    
    let markdownView = MarkdownView(css: nil, plugins: nil)
    
    init() {
        //self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .appColor(.backgroundFirst)
        setupUI()
        
        markdownView.load(markdown: mdstring)
    }
    

    func setupUI() {
        [markdownView].forEach({self.view.addSubview($0)})
        
        markdownView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
