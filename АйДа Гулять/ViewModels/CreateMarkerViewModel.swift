//
//  CreateMarkerViewModel.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 29.12.2022.
//

import UIKit
import Combine
import Apollo
import ApolloCombine


class CreateMarkerViewModel: NSObject, ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    let coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init()
        self.setupBindings()
    }
    
    func setupBindings() {
        
    }
}


extension CreateMarkerViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "add", for: indexPath)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            return cell
        }
    }
}
