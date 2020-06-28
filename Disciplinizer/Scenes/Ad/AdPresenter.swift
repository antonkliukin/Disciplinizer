//
//  AdPresenter.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 14.03.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import Foundation
import GoogleMobileAds

protocol AdPresenterProtocol {
    func viewDidLoad()
}

protocol AdDismissDelegateProtocol: class {
    func didDismiss()
}

class AdPresenter: NSObject, AdPresenterProtocol {
    weak var adDismissDelegate: AdDismissDelegateProtocol?
    
    weak var view: AdViewProtocol?
    var rewardedAd: GADRewardedAd?
    var numberOfAdsToShow = Config.shared.numberOfAds() ?? 3
    var watchedAds = 0

    init(view: AdViewProtocol, adDismissDelegate: AdDismissDelegateProtocol) {
        self.view = view
        self.adDismissDelegate = adDismissDelegate
    }

    func viewDidLoad() {
        rewardedAd = createAndLoadRewardedAd()
    }

    private func createAndLoadRewardedAd() -> GADRewardedAd? {
        guard watchedAds <= numberOfAdsToShow else {
            return nil
        }

        rewardedAd = GADRewardedAd(adUnitID: Config.shared.getAdUnitID())
        rewardedAd?.load(GADRequest()) { [weak self] error in
            if error != nil {
                let alertModel = AlertModel(title: Strings.loseAdAlertFailedTitle(),
                                            message: Strings.loseAdAlertFailedMessage(),
                                            positiveActionTitle: Strings.loseAdAlertFailedAction())
                
                let alertVC = Controller.createAlert(alertModel: alertModel, didTapPositive: { rootVC.dismiss(animated: true, completion: nil) })
                self?.view?.router?.present(alertVC)
            } else {
                guard let self = self, let vc = self.view as? AdViewController else {
                    assertionFailure()
                    return
                }

                self.rewardedAd?.present(fromRootViewController: vc, delegate: self)
            }
        }

        return rewardedAd
    }
}

extension AdPresenter: GADRewardedAdDelegate {

    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        watchedAds += 1

        if watchedAds >= numberOfAdsToShow {
            AppLockManager.shared.changeStateTo(.unlocked)
            KeychainService.appLockState = .unlocked
        }

      print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    }

    func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
      print("Rewarded ad presented.")
    }

    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        print("Rewarded ad dismissed.")

        if watchedAds < numberOfAdsToShow {
            self.rewardedAd = createAndLoadRewardedAd()
        } else {
            rootVC.dismiss(animated: true) {
                self.adDismissDelegate?.didDismiss()
            }
        }
    }

    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
      print("Rewarded ad failed to present.")
    }
}
