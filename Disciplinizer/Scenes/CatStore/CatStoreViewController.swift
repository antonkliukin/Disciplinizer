//
//  CatStoreViewController.swift
//  Disciplinizer
//
//  Created by Anton on 01.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

protocol CatStoreViewProtocol: ViewProtocol {
    var isPresented: Bool { get }
    func set(viewTitle: String)
    func set(description: String)
    func showMotivationItems(_ items: [MotivationalItem])
}

class CatStoreViewController: UIViewController, CatStoreViewProtocol {
        
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var closeButtonImage: UIImageView!
    
    let configurator = CatStoreConfigurator()
    var presenter: CatStorePresenter!
    var isPresented: Bool {
        navigationController == nil
    }
    
    private var items: [MotivationalItem] = []
    private var stackLayout: StackCollectionViewLayout? {
        collectionView.collectionViewLayout as? StackCollectionViewLayout
    }
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        closeButtonImage.isHidden = !isPresented
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        presenter.didTapCloseButton()
    }
    
    func set(viewTitle: String) {
        titleLabel.text = viewTitle
    }
    
    func set(description: String) {
        descriptionLabel.text = description
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
            cell.configure(withItem: item, onBuyButtonTap: {
                self.presenter.didTapBuyButton(onItemWithIndex: indexPath.item)
            })
            
            let shouldBeFocused = indexPath.item == 0
            cell.showBorder(shouldBeFocused)
            
            if shouldBeFocused {
                stackLayout?.focusedCell = cell
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        scrollToIndex(indexPath)
    }
    
    private func scrollToIndex(_ indexPath: IndexPath, animated: Bool = true) {
        guard let layout = stackLayout else {
            return
        }
        
        guard let focusedCell = layout.focusedCell else {
            return
        }
        
        guard let focusedCellIndex = collectionView.indexPath(for: focusedCell)?.row else {
            return
        }
                
        let selectedCellIndex = indexPath.row
        let cellHeight = focusedCell.bounds.height
                
        var newOffset = collectionView.contentOffset
        
        if selectedCellIndex > focusedCellIndex {
            newOffset = CGPoint(x: collectionView.contentOffset.x,
                                    y: collectionView.contentOffset.y + cellHeight)
        } else if selectedCellIndex < focusedCellIndex {
            newOffset = CGPoint(x: collectionView.contentOffset.x,
                                    y: collectionView.contentOffset.y - cellHeight)
        } else {
            return
        }

        collectionView.setContentOffset(newOffset, animated: animated)
    }
}

extension CatStoreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 0, bottom: 300, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 210)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
