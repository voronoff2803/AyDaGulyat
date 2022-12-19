//
//  MyProfileViewModel.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 27.11.2022.
//


import UIKit
import Combine
import Apollo
import ApolloCombine


protocol MyProfileViewModelItem {
    var type: MyProfileViewModel.ItemType { get }
    var rowCount: Int { get }
}

class MyProfileViewModel: NSObject, ObservableObject {
    enum ItemType {
        case person
        case birthDate
        case tags
        case description
        case contacts
        case dogs
    }
    
    let coordinator: Coordinator
    weak var viewController: MyProfileViewController?
    
    var subscriptions = Set<AnyCancellable>()
    
    var items = [MyProfileViewModelItem]() {
        didSet {
            print(items)
            viewController?.tableView.reloadData()
        }
    }
    
    @Published var firstName = ""
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init()
    }
    
    func fetchData(context: AppRootViewController) {
        APIService.shared.myProfile()
            .sink { req in
                switch req {
                case .finished:
                    print("finished")
                case .failure(let error):
                    context.showError(error: error)
                }
            } receiveValue: { res in
                guard let myProfile = res.myProfile else {
                    
                    context.showAlert(label: "Познакомимся?",
                                      message: "Для начала нужно заполнить информацию о себе и своем питомце",
                                      buttons: [DefaultButton(style: .filledAlert, leftIcon: nil, rightIcon: nil).then {
                                            $0.setTitle("Продолжить", for: .normal)
                    }]) {
                        self.coordinator.route(context: context, to: .profileEdit, parameters: nil)
                    }
                    return
                }
                print(myProfile)
                self.showData(myProfile: myProfile)
            }
            .store(in: &subscriptions)
    }
    
    
    func showData(myProfile: MyProfileQuery.Data.MyProfile) {
        if let firstName = myProfile.firstName, let lastName = myProfile.lastName {
            let personItem = PersonCellViewModelItem(name: firstName + " " + lastName, pictureUrl: "")
            items.append(personItem)
        }
    }
}


extension MyProfileViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .person:
            if let cell = tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.identifier, for: indexPath) as? PersonTableViewCell {
                cell.item = item
                return cell
            }
        case .birthDate:
            break
        case .tags:
            break
        case .description:
            break
        case .contacts:
            break
        case .dogs:
            break
        }
        return UITableViewCell()
    }
}
