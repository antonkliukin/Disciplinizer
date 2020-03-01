//
//  SongSelectCell.swift
//  Concentration tracker
//
//  Created by Лаки Ийнбор on 12.11.2019.
//  Copyright © 2019 FutureCompanyName. All rights reserved.
//

import UIKit
import SwiftySound
import AVFoundation

protocol SongSelectCellDelegate: class {
    func didSelect(song: SongModel)
}

class SongSelectCell: UITableViewCell {
    static let reuseId = "SongSelectCell"
    
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var songNameLabel: UILabel!

    weak var delegate: SongSelectCellDelegate?

    private var model: SongModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.playButton.setImage(playImage(active: false), for: .normal)
        let notificationName = Notification.Name("com.moonlightapps.SwiftySound.stopNotification")
        NotificationCenter.default.addObserver(self, selector: #selector(soundDidStop), name: notificationName, object: nil)
    }

    deinit {
        model?.sound?.stop()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected, let model = model {
            SoundManager.shared.selectedSong = SongModel(title: model.title, url: model.url)
            delegate?.didSelect(song: model)
        }
    }
    
    @IBAction func didTapPlayButton(_ sender: UIButton) {
        switchButtonState()
    }
    
    func configure(_ model: SongModel) {
        songNameLabel.text = model.title
        self.model = model
    }
        
    @objc func soundDidStop() {
        self.playButton.setImage(playImage(active: false), for: .normal)
    }
    
    private func switchButtonState() {
        guard let sound = self.model?.sound else { return }
        if sound.playing {
            self.playButton.setImage(playImage(active: false), for: .normal)
            Sound.stopAll()
        } else {
            Sound.stopAll()
            self.playButton.setImage(playImage(active: true), for: .normal)
            sound.play(numberOfLoops: 1, completion: { [weak self] _ in
                self?.playButton.setImage(self?.playImage(active: false), for: .normal)
            })
        }
    }
    
    private func playImage(active: Bool) -> UIImage? {
        let image = active ?  R.image.playFill() :  R.image.play()
        return image
    }
}
