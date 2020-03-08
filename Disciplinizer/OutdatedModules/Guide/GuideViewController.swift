//
//  GuideViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 12/09/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol GuideViewProtocol: ViewProtocol {
    func openPage(withIndex index: Int)
    func changeNextButtonState(isReadyToFinish: Bool)
    func reloadData()
}

class GuideViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControlContainer: UIView!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    private var pageControl: CustomPageControl!

    var presenter: GuidePresenterProtocol?
    var pages: [PageModel] {
        return presenter?.getPageViewModels() ?? []
    }
    var currentCellIndex: Int {
        return presenter?.currentPageIndex ?? 0
    }

    let collectionViewMargin: CGFloat = 0
    let cellSpacing: CGFloat = 0
    var cellWidth: CGFloat = 0
    var cellHeight: CGFloat {
        return collectionView.bounds.height
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        presenter?.viewDidLoad()
        setup()
    }

    @IBAction func nextButtonTapped(_ sender: Any) {
        presenter?.nextPageTapped()
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
        presenter?.closeTapped()
    }

    private func setup() {
        pageControl = CustomPageControl(frame: pageControlContainer.bounds)
        pageControlContainer.addSubview(pageControl)

        collectionView.delegate = self
        collectionView.dataSource = self

        let bundle = Bundle(for: PageCollectionViewCell.self)
        let nib = UINib(nibName: PageCollectionViewCell.nameOfClass, bundle: bundle)
        collectionView.register(nib, forCellWithReuseIdentifier: PageCollectionViewCell.reuseId)

        let layout = UICollectionViewFlowLayout()
        collectionView?.collectionViewLayout = layout
        collectionView?.decelerationRate = .fast
        collectionView?.bounces = false

        cellWidth =  UIScreen.main.bounds.width - collectionViewMargin * 2.0
        layout.headerReferenceSize = CGSize(width: collectionViewMargin, height: 0)
        layout.footerReferenceSize = CGSize(width: collectionViewMargin, height: 0)

        layout.minimumLineSpacing = cellSpacing
        layout.scrollDirection = .horizontal
    }
}

extension GuideViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.configureWith(numberOfDots: pages.count)

        return pages.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCollectionViewCell.reuseId, for: indexPath)

        if let cell = cell as? PageCollectionViewCell {
            let page = pages[indexPath.row]
            cell.configure(with: page.titleText, content: page.contentText)
        }

        return cell
    }
}

extension GuideViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

extension GuideViewController: UIScrollViewDelegate {
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let pageWidth = Float(cellWidth + cellSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(collectionView!.contentSize.width  )
        var newPageIndex = Float(currentCellIndex)

        if velocity.x == 0 {
            newPageIndex = floor((targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPageIndex = Float(velocity.x > 0 ? currentCellIndex + 1 : currentCellIndex - 1)
            if newPageIndex < 0 {
                newPageIndex = 0
            }
            if newPageIndex > (contentWidth / pageWidth) {
                newPageIndex = ceil(contentWidth / pageWidth) - 1.0
            }
        }

        let point = CGPoint(x: CGFloat(newPageIndex * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point

        presenter?.didScrollToPage(atIndex: Int(newPageIndex))
        pageControl.currentIndex = currentCellIndex
    }
}

extension GuideViewController: GuideViewProtocol {
    func changeNextButtonState(isReadyToFinish: Bool) {
        let nextButtonTitle = isReadyToFinish ? Strings.guideGotIt() : Strings.guideNext()

        UIView.animate(withDuration: 0.3) {
            self.closeButton.isHidden = isReadyToFinish
            self.pageControlContainer.isHidden = isReadyToFinish
            self.nextButton.setTitle(nextButtonTitle, for: .normal)
        }
    }

    func openPage(withIndex index: Int) {
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.currentIndex = index
    }

    public func reloadData() {
        collectionView.reloadData()
    }
}
