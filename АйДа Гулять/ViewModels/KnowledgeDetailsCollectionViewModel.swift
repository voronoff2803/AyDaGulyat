//
//  KnowledgeDetailsCollectionViewModel.swift
//  АйДа Гулять
//
//  Created by Alexey Voronov on 25.12.2022.
//

import UIKit
import Combine
import Apollo
import ApolloCombine
import Aida


class KnowledgeDetailsCollectionViewModel: NSObject, ObservableObject {
    var subscriptions = Set<AnyCancellable>()
    
    let coordinator: Coordinator
    
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}


extension KnowledgeDetailsCollectionViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
}


extension KnowledgeDetailsCollectionViewModel: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let parentViewController = collectionView.parentViewController else { return }
        coordinator.route(context: parentViewController, to: .empty, parameters: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                     withReuseIdentifier: KnowledgeDetailHeaderView.identifier,
                                                                     for: indexPath) as! KnowledgeDetailHeaderView
        header.setupUI()
        return header
    }

}


extension KnowledgeDetailsCollectionViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: .zero, height: 300)
    }
}
