//
//  ProfileBigViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 02.11.2022.
//

import UIKit
import Hero


class ProfileBigViewController: UIViewController {
    weak var mapView: UIView?
    
    var isUserDrag = false
    
    let tableView = UITableView().then {
        $0.bounces = true
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.reloadData()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    
    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        self.navigationItem.title = "Мой профиль"
        
        [tableView].forEach({self.view.addSubview($0)})
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}


extension ProfileBigViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
}


extension ProfileBigViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        switch index {
        case 3:
            let cell = tableView.cellForRow(at: indexPath) as! DescriptionTableViewCell
            cell.cellState = (cell.cellState == .normal) ? .extended : .normal
            tableView.performBatchUpdates(nil)
            break
        case 8:
            let cell = tableView.cellForRow(at: indexPath) as! DogProfileDescriptionTableViewCell
            cell.cellState = (cell.cellState == .normal) ? .extended : .normal
            tableView.performBatchUpdates(nil)
        default:
            break
        }
    }
}


extension ProfileBigViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let inset = scrollView.bounds.origin.y
        
        if inset < -50, isUserDrag {
            if !Hero.shared.isTransitioning {
                dismiss(animated: true, completion: nil)
                mapView?.isHidden = false
            }
        }
//
//        if inset < 0, isUserDrag {
//            Hero.shared.update((-inset - 50) / 300)
//        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserDrag = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isUserDrag = false
//
//        let inset = scrollView.bounds.origin.y
//
//        if Hero.shared.isTransitioning {
//            if inset < -100 {
//                Hero.shared.finish()
//            } else {
//                Hero.shared.cancel()
//            }
//        }
    }
}
