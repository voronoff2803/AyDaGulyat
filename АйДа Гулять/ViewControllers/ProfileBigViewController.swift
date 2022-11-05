//
//  ProfileBigViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 02.11.2022.
//

import UIKit
import Hero



class ProfileBigViewController: UIViewController {
    var isUserDrag = false
    
    let tableView = UITableView().then {
        $0.bounces = true
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        tableView.register(PersonCollectionViewCell.self,
                           forCellReuseIdentifier: PersonCollectionViewCell.reusableID)
        
        tableView.register(BirthDateCollectionViewCell.self,
                           forCellReuseIdentifier: BirthDateCollectionViewCell.reusableID)
        
        tableView.register(TagsTableViewCell.self,
                           forCellReuseIdentifier: TagsTableViewCell.reusableID)
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
        print("viewDidLayoutSubviews")
        print(tableView.frame)
        tableView.reloadData()
    }

    
    
    func setupUI() {
        self.view.backgroundColor = .appColor(.backgroundFirst)
        
        [tableView].forEach({self.view.addSubview($0)})
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}


extension ProfileBigViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        switch index {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: PersonCollectionViewCell.reusableID,
                                                        for: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier:BirthDateCollectionViewCell.reusableID,
                                                          for: indexPath)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier:TagsTableViewCell.reusableID,
                                                          for: indexPath) as! TagsTableViewCell
            cell.tableViewWidth = tableView.frame.width
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier:BirthDateCollectionViewCell.reusableID,
                                                          for: indexPath)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}


extension ProfileBigViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension ProfileBigViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let inset = scrollView.bounds.origin.y
        
        if inset < -50, isUserDrag {
            if !Hero.shared.isTransitioning { dismiss(animated: true, completion: nil)}
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
