//
//  HistoryViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 31.10.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol HistoryViewProtocol: ViewProtocol {
    func showError(errorMessage: String)
    func refresh()
}

final class HistoryViewController: UIViewController, HistoryViewProtocol {
    @IBOutlet private weak var tableView: UITableView!

    var presenter: HistoryPresenterProtocol!

    private let configurator = HistoryConfigurator()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = title

        configurator.configure(historyViewController: self)

        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        presenter.viewWillAppear()
    }

    @IBAction func clearButtonTapped(_ sender: Any) {
        presenter.clearButtonTapped()
    }

    func showError(errorMessage: String) {
        print("Error occured: \(errorMessage)")
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

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        presenter.titleForDate(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: HistoryChallengeCell.reuseId, for: indexPath) as? HistoryChallengeCell {
            presenter.configure(cell: cell, forRow: indexPath.row, inSection: indexPath.section)

            return cell
        }

        return UITableViewCell()
    }
}
