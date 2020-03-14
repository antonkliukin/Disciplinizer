//
//  MusicSelectViewController.swift
//  Disciplinizer
//
//  Created by Лаки Ийнбор on 11.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol MusicSelectionViewProtocol: ViewProtocol {
    func setupSongsList(songs: [Song])
}

final class MusicSelectViewController: UIViewController, MusicSelectionViewProtocol {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var shadowView: UIView!
    private var transitionPositionObserver: NSKeyValueObservation?

    var presenter: MusicSelectionPresenterProtocol?
    var configurator = MusicSelectionConfigurator()
    var songs: [Song] = []

    func setupSongsList(songs: [Song]) {
        self.songs = songs
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(musicSelectionViewController: self)

        presenter?.viewDidLoad()

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
            //self.presenter?.didSelect(song: self.selectedSong)
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
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SongSelectCell.reuseId, for: indexPath)
        
        if let cell = cell as? SongSelectCell {
            cell.setTitle(songs[indexPath.row].title)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            assertionFailure()
            return
        }

        cell.setSelected(true, animated: true)
        presenter?.didSelect(song: songs[indexPath.row])
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            assertionFailure()
            return
        }

        cell.setSelected(false, animated: true)
    }
}
