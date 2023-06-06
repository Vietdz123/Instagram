//
//  BottomProfileController.swift
//  Instagram
//
//  Created by Long Bảo on 11/05/2023.
//

import UIKit

protocol BottomProfileControllerDelegate: AnyObject {
    func didSelectStatus(status: StatusModel)
}

class BottomProfileController: BottomController {
    //MARK: - Properties
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    override var bottomTabTripCollectionView: UICollectionView {
        return collectionView
    }
    var statuses: [StatusModel] = []
    weak var delegate: BottomProfileControllerDelegate?
    var user: UserModel? {
        didSet {
            guard let user = user else {
                return
            }

            StatusService.shared.fetchStatusUser(uid: user.uid) { status in
                self.statuses.append(contentsOf: status)
                self.collectionView.reloadData()
            }
        }
    }
    
    
    //MARK: - View Lifecycle
    deinit {
        print("DEBUG: BottomController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(BottomProfileCollectionViewCell.self, forCellWithReuseIdentifier: BottomProfileCollectionViewCell.identifier)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.collectionViewLayout = self.createLayoutCollectionView()
    }
    
    
    
    //MARK: - Selectors
    func createLayoutCollectionView() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3),
                                              heightDimension: .fractionalHeight(1.0))
        let item = ComposionalLayout.createItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(1 / 3 ))
        let group = ComposionalLayout.createGroup(axis: .horizontal,
                                                  layoutSize: groupSize,
                                                  item: item,
                                                  count: 3)
        group.interItemSpacing = .fixed(1)
        
        let section = ComposionalLayout.createSectionWithouHeader(group: group)
        section.interGroupSpacing = 1
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
//MARK: - delegate
extension BottomProfileController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statuses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomProfileCollectionViewCell.identifier, for: indexPath) as! BottomProfileCollectionViewCell
        let url = URL(string: self.statuses[indexPath.row].postImage.imageURL)
        cell.photoImage.sd_setImage(with: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectStatus(status: statuses[indexPath.row])
    }
}

