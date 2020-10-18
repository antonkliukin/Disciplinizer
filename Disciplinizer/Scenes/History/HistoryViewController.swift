//
//  HistoryViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 31.10.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol HistoryViewProtocol: ViewProtocol {
    func set(viewTitle: String)
    func set(todayScoreTitle: String, bestScoreTitle: String)
    func set(clearButtonTitle: String)
    func display(todayTotalDuration: String)
    func display(bestTotalDuraion: String)
    func configure(noHistoryMessage: String)
    func refresh()
}

final class HistoryViewController: UIViewController, HistoryViewProtocol {
    @IBOutlet private weak var topBackgroundView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var bestResultView: UIView!
    @IBOutlet private weak var todayTotalDurationLabel: UILabel!
    @IBOutlet private weak var bestTotalDuraionLabel: UILabel!
    @IBOutlet private weak var noHistoryLabel: UILabel!
    @IBOutlet private weak var todayScoreTitleLabel: UILabel!
    @IBOutlet private weak var bestScoreTitleLabel: UILabel!
    @IBOutlet private weak var clearButton: UIButton!
    
    var presenter: HistoryPresenterProtocol!

    private let configurator = HistoryConfigurator()

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(historyViewController: self)

        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 100
                
        let headerNib = UINib(nibName: "HistoryHeaderView", bundle: .main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "HistoryHeaderView")
        
        configureTopBackgroundView()
        configureBestResultView()
        
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
        
        navigationController?.navigationBar.isHidden = true
    }
    
    func set(viewTitle: String) {
        titleLabel.text = viewTitle
    }
    
    func set(todayScoreTitle: String, bestScoreTitle: String) {
        todayScoreTitleLabel.text = todayScoreTitle
        bestScoreTitleLabel.text = bestScoreTitle
    }
    
    func set(clearButtonTitle: String) {
        clearButton.setTitle(clearButtonTitle, for: .normal)
    }
    
    private func configureTopBackgroundView() {
        topBackgroundView.roundCorners(corners: .bottom, radius: 24)
    }
    
    private func configureBestResultView() {
        bestResultView.roundCorners(corners: .all, radius: 8)
        bestResultView.addShadow()
    }
    
    func display(todayTotalDuration: String) {
        todayTotalDurationLabel.text = todayTotalDuration
    }
    
    func display(bestTotalDuraion: String) {
        bestTotalDuraionLabel.text = bestTotalDuraion
    }
    
    func configure(noHistoryMessage: String) {
        noHistoryLabel.isHidden = presenter.numberOfDates > 0
        noHistoryLabel.text = noHistoryMessage
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        presenter.clearButtonTapped()
    }

    func refresh() {
        noHistoryLabel.isHidden = presenter.numberOfDates > 0
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
            "HistoryHeaderView") as? HistoryHeaderView {
            presenter.configure(header: view, forSection: section)
            
            return view
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.didTapDelete(forRow: indexPath.row, inSection: indexPath.section)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadSections([indexPath.section], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: HistoryChallengeCell.reuseId, for: indexPath) as? HistoryChallengeCell {
            presenter.configure(cell: cell, forRow: indexPath.row, inSection: indexPath.section)

            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
}
