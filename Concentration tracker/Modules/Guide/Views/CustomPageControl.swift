//
//  CustomPageControl.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 12/09/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

public class CustomPageControl: UIView {
    private enum DotState {
        case selected, unselected
    }

    private var dotsStackView: UIStackView!
    private var contentView: UIView!
    private var numberOfDots = 1

    var currentIndex = 0 {
        willSet(nextIndex) {
            setState(.unselected, forDotAt: currentIndex)
            setState(.selected, forDotAt: nextIndex)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        configureStackView()
    }

    private func configureStackView() {
        dotsStackView = UIStackView(frame: frame)
        dotsStackView.translatesAutoresizingMaskIntoConstraints = false
        dotsStackView.alignment = .center
        dotsStackView.distribution = .fillEqually
        dotsStackView.spacing = 10
        addSubview(dotsStackView)

        dotsStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        dotsStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    private func createDot() -> UIView {
        let dotView = UIView()
        let height: CGFloat = 4
        let width: CGFloat = height

        dotView.heightAnchor.constraint(equalToConstant: height).isActive = true
        dotView.widthAnchor.constraint(equalToConstant: width).isActive = true
        dotView.backgroundColor = R.color.ctOrange()
        dotView.layer.cornerRadius = height / 2

        return dotView
    }

    private func setState(_ state: DotState, forDotAt index: Int) {
        let scale: CGFloat = state == .selected ? 2 : 1

        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.dotsStackView.arrangedSubviews[index].transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }

    func configureWith(numberOfDots: Int) {
        guard numberOfDots > 0 else { return }
        for _ in 1...numberOfDots {
            let dot = createDot()
            dotsStackView.addArrangedSubview(dot)
        }

        setState(.selected, forDotAt: currentIndex)
    }
}
