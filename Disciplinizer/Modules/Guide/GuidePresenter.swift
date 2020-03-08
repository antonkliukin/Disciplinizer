//
//  GuidePresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 12/09/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import Foundation

protocol GuidePresenterProtocol: class {
    var currentPageIndex: Int { get set }
    func viewDidLoad()
    func nextPageTapped()
    func closeTapped()
    func didScrollToPage(atIndex index: Int)
    func getPageViewModels() -> [PageModel]?
}

class GuidePresenter {
    weak var view: GuideViewProtocol?

    var pageModels: [PageModel]?

    var isReadyToFinish = false
    var currentPageIndex = 0 {
        didSet {
            let lastPageIndex = (pageModels?.count ?? 0) - 1
            guard currentPageIndex >= 0, currentPageIndex <= lastPageIndex else {
                currentPageIndex = oldValue
                return
            }

            isReadyToFinish = currentPageIndex >= lastPageIndex
            view?.changeNextButtonState(isReadyToFinish: isReadyToFinish)
        }
    }

    required init(view: GuideViewProtocol) {
        self.view = view
    }
}

extension GuidePresenter: GuidePresenterProtocol {
    func viewDidLoad() {
        pageModels = PageProvider().getPages()
    }

    func getPageViewModels() -> [PageModel]? {
        return PageProvider().getPages()
    }

    func didScrollToPage(atIndex index: Int) {
        currentPageIndex = index
    }

    func nextPageTapped() {
        guard !isReadyToFinish else {
            dismiss()
            return
        }

        let previousIndex = currentPageIndex
        currentPageIndex += 1
        if previousIndex != currentPageIndex {
            view?.openPage(withIndex: currentPageIndex)
        }
    }

    func closeTapped() {
        dismiss()
    }

    func dismiss() {
        KeychainService.setGuideState(isWatched: true)
        view?.router?.dismiss()
    }
}
