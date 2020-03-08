//
//  MusicSelectViewController.swift
//  Disciplinizer
//
//  Created by Лаки Ийнбор on 11.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol MusicSelectViewDelegate: class {
    func didSelect(song: SongModel?)
}

protocol MusicSelectViewProtocol: ViewProtocol {
}

final class MusicSelectViewController: UIViewController, MusicSelectViewProtocol {
    @IBOutlet private weak var shadowView: UIView!
    private var transitionPositionObserver: NSKeyValueObservation?
    private var selectedSong: SongModel?
    
    var presenter: MusicSelectPresenterProtocol?
    
    weak var delegate: MusicSelectViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDismissSwipe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.3, delay: 0.3, animations: {
            self.shadowView.alpha = 1
        })
    }
    
    @objc private func dismissActionPerformed() {
        customDismiss()
    }
    
    func customDismiss() {
        UIView.animate(withDuration: 0.1, animations: {
            self.shadowView.alpha = 0
        }, completion: { _ in
            self.presenter?.didSelect(song: self.selectedSong)
            self.delegate?.didSelect(song: nil)
        })
    }
    
    private func configureDismissSwipe() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissActionPerformed))
        swipeDown.direction = .down
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissActionPerformed))
        view.addGestureRecognizer(swipeDown)
        shadowView.addGestureRecognizer(tap)
    }
}

extension MusicSelectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.songModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongSelectCell.reuseId, for: indexPath)
        
        if let cell = cell as? SongSelectCell, let presenter = presenter {
            cell.configure(presenter.songModels[indexPath.row])
            cell.delegate = self
        }
        
        return cell
    }
}

extension MusicSelectViewController: SongSelectCellDelegate {
    func didSelect(song: SongModel) {
        selectedSong = song
        delegate?.didSelect(song: song)
        customDismiss()
    }
}
