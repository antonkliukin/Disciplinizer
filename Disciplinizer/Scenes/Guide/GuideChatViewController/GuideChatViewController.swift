//
//  GuideChatViewController.swift
//  Disciplinizer
//
//  Created by Anton on 10.05.2020.
//  Copyright © 2020 Anton Kliukin. All rights reserved.
//

import UIKit

protocol GuideChatViewProtocol: ViewProtocol {
    func set(nextButtonTitle: String)
}

class GuideChatViewController: UIViewController, GuideChatViewProtocol {
    @IBOutlet weak var nextButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButton: MainButton!
    
    var presenter: GuideChatPresenterProtocol?

    private var collectionViewHeight: NSLayoutConstraint?
    private var timer: Timer?
    
    private var messagesToShow = [
            ChatMessage(text: Strings.guideMessage1()),
            ChatMessage(text: Strings.guideMessage2()),
            ChatMessage(text: Strings.guideMessage3()),
            ChatMessage(text: Strings.guideMessage4()),
            ChatMessage(text: Strings.guideMessage5()),
            ChatMessage(text: Strings.guideMessage6()),
            ChatMessage(text: Strings.guideMessage7()),
            ChatMessage(text: Strings.guideMessage8()),
            ChatMessage(text: Strings.guideMessage9())
    ]
    
    private var sections: [[ChatMessage]] = [[ChatMessage(text: "")]]
    private let configurator = GuideChatConfigurator()
    private var collectionView = ChatCollectionView(sections: [[]])
    private let itemHeight: CGFloat = 110
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(guideChatViewController: self)
        
        presenter?.viewDidLoad()
        
        addCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nextButtonHeightConstraint.constant = 0
        view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.flowLayout.itemSize = CGSize(width: view.bounds.size.width - 50, height: itemHeight)
        collectionView.flowLayout.minimumLineSpacing = 0
        collectionView.flowLayout.minimumInteritemSpacing = 0
        updateCollectionView()

        startTimer()
    }
    
    func set(nextButtonTitle: String) {
        nextButton.setTitle(nextButtonTitle, for: .normal)
    }
    
    private func updateCollectionView() {
        collectionView.sections = sections
        updateCollectionViewHeight()
        collectionView.reloadData()
        collectionView.scrollToItem(at: IndexPath(item: sections[0].count - 1, section: 0), at: .bottom, animated: true)
    }
    
    var collectionBottonConstraint: NSLayoutConstraint?
    var collectionButtonConstraint: NSLayoutConstraint?
    var collectionTopConstraint: NSLayoutConstraint?
        
    private func addCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)

        collectionViewHeight = collectionView.heightAnchor.constraint(equalToConstant: itemHeight)
        collectionViewHeight?.isActive = true
        collectionTopConstraint = collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        collectionTopConstraint?.isActive = false
        
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionBottonConstraint = collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        collectionBottonConstraint?.isActive = true
        collectionButtonConstraint = collectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -50)
        collectionButtonConstraint?.isActive = false
        
        collectionView.register(UINib(nibName: ChatCell.id, bundle: .main), forCellWithReuseIdentifier: ChatCell.id)
    }
    
    private func updateCollectionViewHeight() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        
        if collectionViewHeight!.constant >= safeAreaHeight {
            collectionViewHeight?.isActive = false
            collectionTopConstraint?.isActive = true
        } else {
            collectionViewHeight?.constant = CGFloat(sections[0].count) * itemHeight
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true) { (_) in
            let indexForNewMessage = self.sections[0].count - 1
            
            guard indexForNewMessage < self.messagesToShow.count else { return }
            
            let newMessage = self.messagesToShow[indexForNewMessage]
            self.sections[0].insert(newMessage, at: self.sections[0].count - 1)
                        
            if indexForNewMessage >= self.messagesToShow.count - 1 {
                self.sections[0].removeLast()
                self.timer?.invalidate()
                self.nextButtonHeightConstraint.constant = 44
                self.collectionBottonConstraint?.isActive = false
                self.collectionButtonConstraint?.isActive = true
            }
            
            self.updateCollectionView()
        }
    }
    
    @IBAction func gotItButtonTapped(_ sender: Any) {
        presenter?.didTapGotItButton()
    }
}
