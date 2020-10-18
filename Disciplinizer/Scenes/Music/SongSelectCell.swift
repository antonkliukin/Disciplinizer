//
//  SongSelectCell.swift
//  Disciplinizer
//
//  Created by Лаки Ийнбор on 12.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

class SongSelectCell: UITableViewCell {
    static let reuseId = "SongSelectCell"
    
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var songNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

    func configure(title: String, isPlaying: Bool) {
        songNameLabel.text = title
        self.playButton.setImage(playImage(active: isPlaying), for: .normal)
    }

    private func playImage(active: Bool) -> UIImage? {
        let image = active ? R.image.stop_button()! : R.image.play_button()!
        return image
    }
}
