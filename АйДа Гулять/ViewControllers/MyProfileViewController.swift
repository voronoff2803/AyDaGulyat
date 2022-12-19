//
//  MyProfileViewController.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 27.11.2022.
//

import UIKit
import Hero
import Combine
import CombineCocoa


class MyProfileViewController: AppRootViewController {
    private var subscriptions = Set<AnyCancellable>()
    var viewModel: MyProfileViewModel!
    
    var isUserDrag = false
    
    let tableView = UITableView().then {
        $0.bounces = true
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
    }
    
    init(viewModel: MyProfileViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupBindings()
        
        tableView.register(PersonTableViewCell.self, forCellReuseIdentifier: PersonTableViewCell.identifier)
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension

        tableView.dataSource = viewModel
        
        viewModel.fetchData(context: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.reloadData()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func setupBindings() {
        NotificationCenter.default.publisher(for: .userProfileUpdate)
            .sink(receiveValue: { _ in
                self.viewModel.fetchData(context: self)
            })
            .store(in: &subscriptions)
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


extension MyProfileViewController: UITableViewDelegate {
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


extension MyProfileViewController: UIScrollViewDelegate {
    
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
