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

class AdPresenter: NSObject, AdPresenterProtocol {

    weak var view: AdViewProtocol?
    var rewardedAd: GADRewardedAd?
    var numberOfAdsToShow = 3
    var watchedAds = 0

    init(view: AdViewProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        rewardedAd = createAndLoadRewardedAd()
    }

    private func createAndLoadRewardedAd() -> GADRewardedAd? {
        guard watchedAds <= numberOfAdsToShow else {
            return nil
        }

        // TODO: Prod - ca-app-pub-6894098236140382/9379068244
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
        rewardedAd?.load(GADRequest()) { [weak self] error in
            if let error = error {
                print("Loading failed: \(error)")
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

        if watchedAds == numberOfAdsToShow {
            AppLockManager.shared.changeStateTo(.unlocked)
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
            view?.router?.dismiss(animated: true, completion: nil, toRoot: true)
        }
    }

    func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
      print("Rewarded ad failed to present.")
    }
}