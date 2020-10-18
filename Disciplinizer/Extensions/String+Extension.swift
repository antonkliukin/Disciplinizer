//
//  String+Extension.swift
//  Disciplinizer
//
//  Created by Anton on 17.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

extension String {
    func estimateFrameForText(ofFont font: UIFont, inRect rect: CGSize) -> CGRect {
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: font]

        return NSString(string: self).boundingRect(with: rect, options: options, attributes: attributes, context: nil)
    }
}
