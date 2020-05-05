//
//  HistoryViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 31.10.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol HistoryViewProtocol: ViewProtocol {
    func display(todayTotalDuration: String)
    func display(bestTotalDuraion: String)
    func refresh()
}

final class HistoryViewController: UIViewController, HistoryViewProtocol {
    @IBOutlet private weak var topBackgroundView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var bestResultView: UIView!
    @IBOutlet private weak var todayTotalDurationLabel: UILabel!
    @IBOutlet private weak var bestTotalDuraionLabel: UILabel!
    
    var presenter: HistoryPresenterProtocol!

    private let configurator = HistoryConfigurator()

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = title

        configurator.configure(historyViewController: self)

        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 100
                
        tableView.register(HistoryHeaderView.self, forHeaderFooterViewReuseIdentifier: "HistoryHeaderView")
        
        configureTopBackgroundView()
        configureBestResultView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
        
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureTopBackgroundView() {
        topBackgroundView.roundCorners(corners: .bottom, radius: 24)
    }
    
    private func configureBestResultView() {
        bestResultView.roundCorners(corners: .all, radius: 8)
        bestResultView.addShadow(shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.08),
                                 offSet: CGSize(width: 0, height: 4),
                                 opacity: 1,
                                 shadowRadius: 15)
    }
    
    func display(todayTotalDuration: String) {
        todayTotalDurationLabel.text = todayTotalDuration
    }
    
    func display(bestTotalDuraion: String) {
        bestTotalDuraionLabel.text = bestTotalDuraion
    }

    @IBAction func clearButtonTapped(_ sender: Any) {
        presenter.clearButtonTapped()
    }

    func refresh() {
        tableView.reloadData()
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter.numberOfDates
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfChallengesForDate(section: section)
    }

//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        presenter.titleForDate(section: section)
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
            "HistoryHeaderView") as? HistoryHeaderView
        
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: HistoryChallengeCell.reuseId, for: indexPath) as? HistoryChallengeCell {
            presenter.configure(cell: cell, forRow: indexPath.row, inSection: indexPath.section)

            return cell
        }

        return UITableViewCell()
    }
}
