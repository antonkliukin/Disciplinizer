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

protocol AdDismissDelegateProtocol: AnyObject {
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

        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: Config.shared.getAdUnitID(),
                           request: request) { [weak self] ad, error in
            if error != nil {
                let alertModel = AlertModel(title: R.string.localizable.loseAdAlertFailedTitle(),
                                            message: R.string.localizable.loseAdAlertFailedMessage(),
                                            positiveActionTitle: R.string.localizable.loseAdAlertFailedAction())
                
                let alertVC = Controller.createAlert(alertModel: alertModel, didTapPositive: { rootVC.dismiss(animated: true, completion: nil) })
                self?.view?.router?.present(alertVC)
            } else {
                guard let self = self, let vc = self.view as? AdViewController else {
                    assertionFailure()
                    return
                }

                if let ad = self.rewardedAd {
                    ad.present(fromRootViewController: vc) {
                        let reward = ad.adReward
                        print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
                        
                        self.watchedAds += 1
                        
                        if self.watchedAds >= self.numberOfAdsToShow {
                            AppLockManager.shared.changeStateTo(.unlocked)
                            KeychainService.appLockState = .unlocked
                        }
                    }
                } else {
                    print("Ad wasn't ready")
                }
            }
        }

        return rewardedAd
    }
}

extension AdPresenter: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if watchedAds < numberOfAdsToShow {
            self.rewardedAd = createAndLoadRewardedAd()
        } else {
            rootVC.dismiss(animated: true) {
                self.adDismissDelegate?.didDismiss()
            }
        }
    }
}
