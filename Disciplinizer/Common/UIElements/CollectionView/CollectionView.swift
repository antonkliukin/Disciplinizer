//
//  CollectionView.swift
//  Disciplinizer
//
//  Created by Anton on 05.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

public enum CellReuse<T> {
    public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
    public typealias StringLiteralType = String
    case identifier(String)
    case closure((T, IndexPath) -> String)
}

open class CollectionView<Cell: UICollectionViewCell, Item>: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    public typealias CellContextClosure = (Cell, Item, IndexPath, Int) -> Void
    open var didSelect: CellContextClosure?
    open var didFocus: CellContextClosure?
    open var didScroll: ((UIScrollView) -> Void)?

    open var sections: [[Item]]
    open var cellReuseIdentifier: CellReuse<Item>
    open var cellConfig: CellContextClosure
    open var initialConfigureClosure: ((Cell) -> Void)?
    open var preferredIndexPath: IndexPath?

    open var flowLayout: UICollectionViewFlowLayout! {
        collectionViewLayout as? UICollectionViewFlowLayout
    }

    /// CellType class is automatically registered if CellReuse is .Identifier
    public init(sections: [[Item]] = [], layout: UICollectionViewLayout, cellReuseIdentifier: CellReuse<Item> = .identifier("Item"), cellConfig: @escaping (Cell, Item, IndexPath, Int) -> Void) {
        self.sections = sections
        self.cellReuseIdentifier = cellReuseIdentifier
        self.cellConfig = cellConfig

        super.init(frame: .zero, collectionViewLayout: layout)
        registerClass(Cell.self)
        delegate = self
        dataSource = self
        
        // TODO: Delete
        // contentInsetAdjustmentBehavior = .never
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Registers a nib if the cellReuseIdentifier is .Identifier
    open func registerNib(_ nib: UINib) {
        if case .identifier(let identifier) = cellReuseIdentifier {
            register(nib, forCellWithReuseIdentifier: identifier)
        }
    }

    /// Registers a class if the cellReuseIdentifier is .Identifier
    open func registerClass(_ cellType: AnyClass) {
        if case .identifier(let identifier) = cellReuseIdentifier {
            register(cellType, forCellWithReuseIdentifier: identifier)
        }
    }

    open func itemAtIndexPath(_ indexPath: IndexPath) -> Item? {
        if sections.count > indexPath.section {
            if sections[indexPath.section].count > indexPath.row {
                return sections[indexPath.section][indexPath.row]
            }
        }
        return nil
    }

    open func getCellReuseIdentifer(_ item: Item, indexPath: IndexPath) -> String {
        switch cellReuseIdentifier {
        case .identifier(let identifer): return identifer
        case .closure(let closure): return closure(item, indexPath)
        }
    }

    // MARK: UICollectionViewDelegateFlowLayout

    open func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        guard let indexPath = context.nextFocusedIndexPath,
            let cell = cellForItem(at: indexPath) as? Cell,
            let item = itemAtIndexPath(indexPath) else { return }
        didFocus?(cell, item, indexPath, sections[indexPath.section].count)
    }

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll?(scrollView)
    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = cellForItem(at: indexPath) as? Cell,
            let item = itemAtIndexPath(indexPath) else { return }
        didSelect?(cell, item, indexPath, sections[indexPath.section].count)
    }

    open func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        preferredIndexPath
    }

    // MARK: UICollectionViewDataSource

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].count
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = itemAtIndexPath(indexPath)!
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: getCellReuseIdentifer(item, indexPath: indexPath), for: indexPath)
        if let cell = cell as? Cell {
            if cell.tag != 3 {
                initialConfigureClosure?(cell)
            }
            cell.tag = 3
            cellConfig(cell, item, indexPath, sections[indexPath.section].count)
        }

        return cell
    }

    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // Should be overridden
        let emptyView = UICollectionReusableView()
        emptyView.isHidden = true
        return emptyView
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // Should be overriden if customising section header
        .zero
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        // Should be overriden if customising section footer
        .zero
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Should be overriden if customising section header
        flowLayout.sectionInset
    }

    // This is here because it wasn't being called if simply implemented in subclasses. It needs to be overriden
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {}

    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {}

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        flowLayout.minimumLineSpacing
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        flowLayout.minimumInteritemSpacing
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        flowLayout.itemSize
    }
}

// single array helpers
extension CollectionView {

    public var items: [Item] {
        set {
            sections = [newValue]
        }
        get {
            return sections.reduce([]) {
                $0 + $1
            }
        }
    }

    public func reload(_ items: [Item]) {
        self.items = items
        reloadData()
    }
}

extension CollectionView where Cell: CollectionViewCell, Cell.Item == Item {

    /// Automatically configured cell
    public convenience init(sections: [[Item]] = [], layout: UICollectionViewLayout, cellReuseIdentifier: CellReuse<Item> = .identifier("Item")) {
        self.init(sections: sections, layout: layout, cellReuseIdentifier: cellReuseIdentifier) { cell, item, _, _ in
            cell.configure(item)
        }
    }
}

public protocol CollectionViewCell {

    associatedtype Item
    func configure(_ item: Item)
}

extension CollectionView where Item: Hashable {

    public func reloadWithAnimation(_ items: [Item]) {
        let oldItems = self.items
        let needsSection = sections.isEmpty && numberOfSections == 0
        self.items = items
        // swiftlint:disable:next trailing_closure
        performBatchUpdates({
            var index = 0
            var toRemove: [IndexPath] = []
            var toAdd: [IndexPath] = []
            for oldItem in oldItems {
                if !items.contains(oldItem) {
                    toRemove.append(IndexPath(row: index, section: 0))
                }
                index += 1
            }
            index = 0
            for newItem in items {
                if !oldItems.contains(newItem) {
                    toAdd.append(IndexPath(row: index, section: 0))
                }
                index += 1
            }
            self.deleteItems(at: toRemove)
            self.insertItems(at: toAdd)
            if needsSection {
                self.insertSections(IndexSet(integer: 0))
            }
        })
    }
}
