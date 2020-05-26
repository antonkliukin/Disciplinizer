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
            [SettingsSectionItem(title: Strings.settingsNotifications(), action: { (isOn) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }, actionViewType: .switcher(isOn: NotificationManager.shared.isAuthorized()))
            ],
            [SettingsSectionItem(title: Strings.settingsDarkMode(), action: { (isOn) in
                print(isOn)
            }, actionViewType: .switcher(isOn: true))
            ],
            [SettingsSectionItem(title: Strings.settingsEmailUs(), action: { (_) in
                print("")
            }, actionViewType: .tap)
            ],
            [SettingsSectionItem(title: Strings.settingsTerms(), action: { (_) in
                print("")
            }, actionViewType: .tap),
             SettingsSectionItem(title: Strings.settingsPolicy(), action: { (_) in
                 print("")
             }, actionViewType: .tap)
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
    
    @IBAction private func selectMusicButtonTapped(_ sender: Any) {
        presenter?.didTapMusicSelect()
    }
    
    func updateMusicConfiguration(with model: Song) {
        //songNameLabel.text = model.title
    }
}
