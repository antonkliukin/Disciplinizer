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
        self.playButton.setImage(playImage(active: false), for: .normal)
    }

    func setTitle(_ title: String) {
        songNameLabel.text = title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.playButton.setImage(playImage(active: selected), for: .normal)
    }

    private func playImage(active: Bool) -> UIImage? {
        let image = active ? R.image.stop_button()! : R.image.play_button()!
        return image
    }
}
