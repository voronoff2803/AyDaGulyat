//
//  SelectDogsViewModel.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 22.12.2022.
//

import UIKit
import Combine
import Apollo
import ApolloCombine
import Aida


class SelectDogsViewModel: NSObject, ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    
    let coordinator: Coordinator
    
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}


extension SelectDogsViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}
