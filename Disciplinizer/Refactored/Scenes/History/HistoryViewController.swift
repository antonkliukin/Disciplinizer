//
//  HistoryViewController.swift
//  Disciplinizer
//
//  Created by Anton Kliukin on 31.10.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol HistoryViewProtocol: ViewProtocol {
    func show(_ challenges: [Challenge])
    func showError(errorMessage: String)
}

final class HistoryViewController: UIViewController, HistoryViewProtocol {
    @IBOutlet private weak var tableView: UITableView!

    var presenter: HistoryPresenterProtocol?

    private let configurator = HistoryConfigurator()

    private var challenges: [Challenge] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(historyViewController: self)

        tableView.delegate = self
        tableView.dataSource = self

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44

        presenter?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        presenter?.viewDidAppear()
    }

    @IBAction func clearButtonTapped(_ sender: Any) {
        presenter?.clearButtonTapped()
    }

    func show(_ challenges: [Challenge]) {
        self.challenges = challenges
    }

    func showError(errorMessage: String) {
        print("Error occured: \(errorMessage)")
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let challenge = challenges[indexPath.row]

        if let cell = tableView.dequeueReusableCell(withIdentifier: "challengeCellId", for: indexPath) as? ChallengeCell {
            cell.idTitle.text = "ID - \(String(challenge.id))"
            cell.startDateTitle.text = "Started at - \(challenge.startDate!.toString())"
            cell.finishDateTitle.text = "Finished at - \(challenge.finishDate?.toString() ?? "-")"
            cell.durationTitle.text = "Duration - \(String(Int(challenge.duration))) seconds"
            cell.isPaidTitle.text = "Mode - \(String(challenge.isPaid ? "Paid" : "Free"))"
            cell.isSuccessTitle.text = "Result - \(String(challenge.isSuccess ? "Win" : "Lose"))"

            return cell
        }

        return UITableViewCell()
    }
}
