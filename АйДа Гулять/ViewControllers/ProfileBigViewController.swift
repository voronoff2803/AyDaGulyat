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
        
        tableView.register(DescriptionTableViewCell.self,
                           forCellReuseIdentifier: DescriptionTableViewCell.reusableID)
        
        tableView.register(ContactsTableViewCell.self,
                           forCellReuseIdentifier: ContactsTableViewCell.reusableID)
        
        tableView.register(DogProfileTableViewCell.self,
                           forCellReuseIdentifier: DogProfileTableViewCell.reusableID)
        
        tableView.register(DogProfileSpecsTableViewCell.self,
                           forCellReuseIdentifier: DogProfileSpecsTableViewCell.reusableID)
        
        tableView.register(DogProfileFeaturesTableViewCell.self,
                           forCellReuseIdentifier: DogProfileFeaturesTableViewCell.reusableID)
        
        tableView.register(DogProfileDescriptionTableViewCell.self,
                           forCellReuseIdentifier: DogProfileDescriptionTableViewCell.reusableID)
        
        
        
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
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier:DescriptionTableViewCell.reusableID,
                                                          for: indexPath)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier:ContactsTableViewCell.reusableID,
                                                          for: indexPath)
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier:DogProfileTableViewCell.reusableID,
                                                          for: indexPath)
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier:DogProfileSpecsTableViewCell.reusableID,
                                                          for: indexPath) as! DogProfileSpecsTableViewCell
            cell.tableViewWidth = tableView.frame.width
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier:DogProfileFeaturesTableViewCell.reusableID,
                                                          for: indexPath) as! DogProfileFeaturesTableViewCell
            cell.tableViewWidth = tableView.frame.width
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier:DogProfileDescriptionTableViewCell.reusableID,
                                                          for: indexPath) as! DogProfileDescriptionTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier:BirthDateCollectionViewCell.reusableID,
                                                          for: indexPath)
            return cell
        }
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
