//
//  PageNavigationViewController.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 17.10.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol PageNavigationViewProtocol: ViewProtocol {

}

final class PageNavigationViewController: UIViewController, PageNavigationViewProtocol {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var tabbarStackView: UIStackView!
    @IBOutlet private weak var barHighlightView: UIView!
    @IBOutlet private weak var barHighlightViewCenterX: NSLayoutConstraint!
    @IBOutlet private weak var barHighlightViewWidth: NSLayoutConstraint!

    var presenter: PageNavigationPresenterProtocol?
    var controllers: [UIViewController] = [] {
        didSet {
            guard controllers.count == 3 else { fatalError("Must has 3 controllers.") }
            maxPageIndex = controllers.count - 1
        }
    }

    private let configurator = PageNavigationConfigurator()
    private var currentPageIndex = 0
    private var maxPageIndex = 1
    private var barHighlighterAnimator: UIViewPropertyAnimator?

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(pageNavigationViewController: self)

        collectionView.panGestureRecognizer.addTarget(self, action: #selector(pagePanned(recognizer:)))
        view.layoutIfNeeded()
        collectionView.collectionViewLayout.invalidateLayout()

        addTapGesturesToNabBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter?.viewDidAppear()

        currentPageIndex = 1
        collectionView.scrollToItem(at: IndexPath(row: currentPageIndex, section: 0), at: .centeredHorizontally, animated: false)
    }

    private func addTapGesturesToNabBar() {
        for view in tabbarStackView.arrangedSubviews {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateBarHighlightViewToCurrent))
            tapGesture.delegate = self
            view.addGestureRecognizer(tapGesture)
        }
    }

    @objc private func pagePanned(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        var initialConstant: CGFloat = 0

        switch recognizer.state {
        case .changed:
            let fraction = abs(translation.x / view.frame.width)
            initialConstant = barHighlightViewCenterX.constant
            barHighlightViewCenterX.constant = -(translation.x / 10)
        case .ended:
            let isEnoughVelocity = abs(recognizer.velocity(in: view).x) >= 300
            let isEnoughSwipeLenght = abs(translation.x) > view.frame.width / 2

            func returnXToInitialConstant() {
                UIView.animate(withDuration: 0.3) {
                    self.barHighlightViewCenterX.constant = initialConstant
                    self.view.layoutIfNeeded()
                }
            }

            if isEnoughVelocity || isEnoughSwipeLenght {
                if translation.x < 0 {
                    let nextIndex = currentPageIndex + 1
                    guard nextIndex <= maxPageIndex else {
                        returnXToInitialConstant()
                        return
                    }

                    animateBarHighlightViewTo(pageWithIndex: nextIndex)
                } else {
                    let previousIndex = currentPageIndex - 1
                    guard previousIndex >= 0 else {
                        returnXToInitialConstant()
                        return
                    }

                    animateBarHighlightViewTo(pageWithIndex: previousIndex)
                }
            } else {
                returnXToInitialConstant()
            }

        default: return
        }
    }

    @objc private func animateBarHighlightViewToCurrent() {
        animateBarHighlightViewTo(pageWithIndex: currentPageIndex)
        collectionView.scrollToItem(at: IndexPath(row: currentPageIndex, section: 0), at: .centeredHorizontally, animated: true)
    }

    fileprivate func animateBarHighlightViewTo(pageWithIndex index: Int) {
        barHighlighterAnimator?.stopAnimation(true)

        let tabView = tabbarStackView.arrangedSubviews[index]

        barHighlighterAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeOut) {
            self.barHighlightViewCenterX.isActive = false
            self.barHighlightViewWidth.isActive = false

            self.barHighlightViewCenterX = self.barHighlightView.centerXAnchor.constraint(equalTo: tabView.centerXAnchor)
            self.barHighlightViewWidth = self.barHighlightView.widthAnchor.constraint(equalTo: tabView.widthAnchor, multiplier: 1.0)

            self.barHighlightViewCenterX.isActive = true
            self.barHighlightViewWidth.isActive = true
            
            self.view.layoutIfNeeded()
        }

        barHighlighterAnimator?.startAnimation()
        currentPageIndex = index
        let openedVC = controllers[index]
        openedVC.viewDidAppear(true)
    }
}

extension PageNavigationViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.reuseId, for: indexPath)

        if let cell = cell as? PageCell {
            let vc = controllers[indexPath.row]
            addChild(vc)
            cell.hostedView = vc.view
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let controllerWidth = scrollView.contentSize.width / CGFloat(controllers.count)
        let opennedPageIndex = scrollView.contentOffset.x / controllerWidth
        animateBarHighlightViewTo(pageWithIndex: Int(opennedPageIndex))
    }
}

extension PageNavigationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let tappedView = gestureRecognizer.view,
              let index = tabbarStackView.arrangedSubviews.firstIndex(of: tappedView) else {
                return false
        }

        currentPageIndex = index
        return true
    }
}
