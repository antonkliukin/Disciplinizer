//
//  CatStoreViewController.swift
//  Disciplinizer
//
//  Created by Anton on 01.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

protocol CatStoreViewProtocol: ViewProtocol {
    func showMotivationItems(_ items: [MotivationalItem])
}

class CatStoreViewController: UIViewController, CatStoreViewProtocol {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageView: UIView!
    
    let configurator = CatStoreConfigurator()
    var presenter: CatStorePresenter!
    
    private var items: [MotivationalItem] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(catStoreViewController: self)
        
        presenter.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CatStoreCollectionCell", bundle: .main), forCellWithReuseIdentifier: CatStoreCollectionCell.id)
        collectionView.decelerationRate = .fast
        
        setupMessageView()
    }
    
    func showMotivationItems(_ items: [MotivationalItem]) {
        self.items = items
        collectionView.reloadData()
    }
    
    private func setupMessageView() {
        messageView.roundCorners(corners: .all, radius: 16)
        messageView.layer.borderWidth = 2
        messageView.layer.borderColor = R.color.lightGrey()!.cgColor
    }
}

extension CatStoreViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CatStoreCollectionCell.id, for: indexPath)
        
        if let cell = cell as? CatStoreCollectionCell {
            cell.catMotivationView.configure(title: item.title,
                                             itemImage: item.image,
                                             descriptionTitle: "",
                                             description: "",
                                             actionButtonTitle: Strings.buyAction()) {
                                                self.presenter.didTapBuyButton(onItemWithIndex: indexPath.row)
            }
            
            cell.catMotivationView.motivationTitleLabel.backgroundColor = item.color
            cell.catMotivationView.actionButton.backgroundColor = item.color
            cell.catMotivationView.actionButton.setTitleColor(item.textColor, for: .normal)
            cell.catMotivationView.priceLabel.isHidden = false
            cell.catMotivationView.priceLabel.textColor = item.priceColor
            cell.catMotivationView.priceLabel.text = item.price.localizedPrice ?? "Price"
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

extension CatStoreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 0, bottom: 210, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 210)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
