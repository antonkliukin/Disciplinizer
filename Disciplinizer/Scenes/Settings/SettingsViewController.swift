//
//  SettingsViewController.swift
//  Disciplinizer
//
//  Created by Лаки Ийнбор on 10.11.2019.
//  Copyright © 2019 Anton Kliukin. All rights reserved.
//

import UIKit

protocol SettingsViewProtocol: ViewProtocol {
    func set(viewTitle: String)
}

class SettingsViewController: UIViewController, SettingsViewProtocol {
    var presenter: SettingsPresenterProtocol?
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleBackgroundView: UIView!
    
    private var sections: [[SettingsSectionItem]] {
        return [
            [SettingsSectionItem(sectionTitle: R.string.localizable.settingsNotifications(),
                                 title: R.string.localizable.settingsNotifications(),
                                 action: { (isOn) in UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!) },
                                 actionViewType: .switcher(isOn: NotificationManager.shared.isAuthorized()))
            ],
            /*
            [SettingsSectionItem(sectionTitle: R.string.localizable.settingsAppearance(),
                                 title: R.string.localizable.settingsDarkMode(),
                                 action: { (isOn) in print(isOn) },
                                 actionViewType: .switcher(isOn: true))
            ],
            */
            [SettingsSectionItem(sectionTitle: R.string.localizable.settingsWeCare(),
                                 title: R.string.localizable.settingsDrugFund(),
                                 action: { (_) in
                                    if let organizationURL = URL(string: "http://priyut-drug.ru/") {
                                        UIApplication.shared.open(organizationURL)
                                    }
            },
                                 actionViewType: .tap)
            ],
            [SettingsSectionItem(sectionTitle: R.string.localizable.settingsGetInTouch(),
                                 title: R.string.localizable.settingsEmailUs(),
                                 action: { (_) in
                                    if let emailURL = URL(string: "mailto:support@disciplinizer.com") {
                                        UIApplication.shared.open(emailURL)
                                    }
            },
                                 actionViewType: .tap)
            ],
            [SettingsSectionItem(sectionTitle: R.string.localizable.settingsAbout(),
                                 title: R.string.localizable.settingsPolicy(),
                                 action: { (_) in
                                    if let policyURL = URL(string: "http://disciplinizer.com/policy/") {
                                        UIApplication.shared.open(policyURL)
                                    }
             },
                                 actionViewType: .tap)
            ]
        ]
    }
    
    var collectionView = SettingsCollectionView(sections: [[]])
    
    private let configurator = SettingsConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(settingsViewController: self)
        
        titleBackgroundView.roundCorners(corners: .bottom, radius: 24)
        addCollectionView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        collectionView.flowLayout.itemSize = CGSize(width: view.bounds.size.width - 32, height: 50)
        collectionView.sections = sections
        collectionView.reloadData()
    }
    
    func set(viewTitle: String) {
        titleLabel.text = viewTitle
    }
    
    @objc private func didBecomeActive() {
        collectionView.sections = sections
        collectionView.reloadData()
    }
    
    private func addCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: titleBackgroundView.bottomAnchor, constant: 80).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collectionView.register(UINib(nibName: SettingsCell.id, bundle: .main), forCellWithReuseIdentifier: SettingsCell.id)
        collectionView.register(SettingsSectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "SettingsSectionHeader")
    }
}
