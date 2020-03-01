//
//  MainPresenter.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 24/08/2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
//

import Foundation

protocol MainPresenterProtocol {
    func viewDidSomething()
    func playButtonTapped()
}

class MainPresenter: MainPresenterProtocol {
    weak var view: MainViewProtocol?

    required init(view: MainViewProtocol) {
        self.view = view
    }

    func playButtonTapped() {
//        Sound.category = .playback
//        Sound.play(url: R.file.pianoWav()!, numberOfLoops: -1)
    }

    func viewDidSomething() {
        // Setup something in view
        view?.setButtonLabel(label: "Show onboarding")

        // Make API call
//        LockStateRequestManager.shared.getUserInfo { (result) in
//            switch result {
//            case .success(let value):
//                print(value)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }

        // TODO: Delete later
        // Present another VC
        /*
         let locString = Strings.alertExample()
         let locDict = Strings.timerMinLeft(value: 2)
         let alertMessage = "\(locString), \(locDict)"

         view.router?.present(Controller.alert(alertMessage))
         */

        view?.router?.present(Controller.createChallenge())
    }
}
