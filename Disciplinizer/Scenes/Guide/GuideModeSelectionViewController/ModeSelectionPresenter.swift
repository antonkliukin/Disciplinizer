//
//  ModeSelectionPresenter.swift
//  Disciplinizer
//
//  Created by Anton on 10.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation

protocol ModeSelectionPresenterProtocol {
    func didTapCatMode()
    func didTapTimeMode()
    func didTapNextButton()
    func viewDidLoad()
}

protocol RouterDelegateProtocol: AnyObject {
    func didTapNext()
}

final class ModeSelectionPresenter: ModeSelectionPresenterProtocol {
    weak var view: ModeSelectionViewProtocol?
    weak var routerDelegate: RouterDelegateProtocol?
    
    private var selectedItem: MotivationalItem = .ad
    private var paidItem: MotivationalItem?
    private var motivationalItemParameterUseCase: MotivationParameterUseCaseProtocol
    
    init(view: ModeSelectionViewProtocol,
         routerDelegate: RouterDelegateProtocol?,
         motivationalItemParameterUseCase: MotivationParameterUseCaseProtocol) {
        self.view = view
        self.routerDelegate = routerDelegate
        self.motivationalItemParameterUseCase = motivationalItemParameterUseCase
    }
    
    func viewDidLoad() {
        configureView()
        selectDefaultMode()
        configureModeViews()
        getPaidItem()
    }
    
    private func getPaidItem() {
        motivationalItemParameterUseCase.getPaid { (result) in
            self.paidItem = try? result.get()
        }
    }
    
    private func configureView() {
        view?.display(titleText: R.string.localizable.guideMotivationSelectionTitle())
        view?.display(descriptionText: R.string.localizable.guideMotivationSelectionDescription())
        view?.configureNextButtonTitle(title: R.string.localizable.guideNextButtonTitle())
    }
    
    private func selectDefaultMode() {
        view?.changeCatModeViewState(.selected)
        view?.changeTimeModeViewState(.unselected)
        view?.display(message: R.string.localizable.guideCatMotivationMessage())
    }
    
    private func configureModeViews() {
        view?.configureCatModeView(title: R.string.localizable.guideCatMotivationTitle(),
                                   desctiption: R.string.localizable.guideCatMotivationDescription(),
                                   image: R.image.paw()!)
        view?.configureTimeModeView(title: R.string.localizable.guideTimeMotivationTitle(),
                                    desctiption: R.string.localizable.guideTimeMotivationDescription(),
                                    image: R.image.timer_guide()!)
    }
    
    func didTapCatMode() {
        selectedItem = paidItem ?? .ad
        view?.changeCatModeViewState(.selected)
        view?.changeTimeModeViewState(.unselected)
        view?.display(message: R.string.localizable.guideCatMotivationMessage())
    }
    
    func didTapTimeMode() {
        selectedItem = .ad
        view?.changeCatModeViewState(.unselected)
        view?.changeTimeModeViewState(.selected)
        view?.display(message: R.string.localizable.guideTimeMotivationMessage())
    }
    
    func didTapNextButton() {
        motivationalItemParameterUseCase.select(motivationalItem: selectedItem) { (_) in }
        routerDelegate?.didTapNext()
    }
}
