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

protocol RouterDelegateProtocol: class {
    func didTapNext()
}

final class ModeSelectionPresenter: ModeSelectionPresenterProtocol {
    func viewDidLoad() {
        configureView()
        selectDefaultMode()
        configureModeViews()
    }
    
    weak var view: ModeSelectionViewProtocol?
    weak var routerDelegate: RouterDelegateProtocol?
    
    private var selectedMode: MotivationalItem = .level1
    private var motivationalItemParameterUseCase: MotivationParameterUseCaseProtocol
    
    init(view: ModeSelectionViewProtocol,
         routerDelegate: RouterDelegateProtocol?,
         motivationalItemParameterUseCase: MotivationParameterUseCaseProtocol) {
        self.view = view
        self.routerDelegate = routerDelegate
        self.motivationalItemParameterUseCase = motivationalItemParameterUseCase
    }
    
    private func configureView() {
        view?.display(titleText: Strings.guideMotivationSelectionTitle())
        view?.display(descriptionText: Strings.guideMotivationSelectionDescription())
    }
    
    private func selectDefaultMode() {
        view?.changeCatModeViewState(.selected)
        view?.changeTimeModeViewState(.unselected)
        view?.display(message: Strings.guideCatMotivationMessage())
    }
    
    private func configureModeViews() {
        view?.configureCatModeView(title: Strings.guideCatMotivationTitle(),
                                   desctiption: Strings.guideCatMotivationDescription(),
                                   image: R.image.paw()!)
        view?.configureTimeModeView(title: Strings.guideTimeMotivationTitle(),
                                    desctiption: Strings.guideTimeMotivationDescription(),
                                    image: R.image.timer_guide()!)
    }
    
    func didTapCatMode() {
        selectedMode = .level1
        view?.changeCatModeViewState(.selected)
        view?.changeTimeModeViewState(.unselected)
        view?.display(message: Strings.guideCatMotivationMessage())
    }
    
    func didTapTimeMode() {
        selectedMode = .ad
        view?.changeCatModeViewState(.unselected)
        view?.changeTimeModeViewState(.selected)
        view?.display(message: Strings.guideTimeMotivationMessage())
    }
    
    func didTapNextButton() {
        motivationalItemParameterUseCase.select(motivationalItem: selectedMode) { (_) in }
        routerDelegate?.didTapNext()
    }
}
