//
//  PageProvider.swift
//  Concentration tracker
//
//  Created by Anton Kliukin on 12/09/2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol PageProviderProtocol {
    func getPages() -> [PageModel]
}

class PageProvider: PageProviderProtocol {
    let onboardingTexts = [Strings.guideFirstPageContent(), Strings.guideSecondPageContent(), Strings.guideThirdPageContent()]
     let onboardingTitles = [Strings.guideFirstPageTitle(), Strings.guideSecondPageTitle(), Strings.guideThirdPageTitle()]
    
    func getPages() -> [PageModel] {
        let pageCount = 3
        return (0..<pageCount).map { PageModel(titleText: onboardingTitles[$0], contentText: onboardingTexts[$0]) }
    }
}
