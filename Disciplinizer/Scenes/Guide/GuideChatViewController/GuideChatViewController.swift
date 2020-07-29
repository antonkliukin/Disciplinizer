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
    func set(typingLabelText: String)
}

class GuideChatViewController: UIViewController, GuideChatViewProtocol {
    @IBOutlet weak var nextButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextButton: MainButton!
    @IBOutlet weak var typingLabel: UILabel!
    @IBOutlet weak var dotsStack: UIStackView!
    @IBOutlet weak var topView: UIView!
    
    var presenter: GuideChatPresenterProtocol?

    private var timer: Timer?
    private var isAnimationRunning = false
    // TODO: Refactor. It'd be better to inject this data. 
    private var messagesToShow = [
            ChatMessage(text: Strings.guideMessage2()),
            ChatMessage(text: Strings.guideMessage3()),
            ChatMessage(text: Strings.guideMessage4()),
            ChatMessage(text: Strings.guideMessage5()),
            ChatMessage(text: Strings.guideMessage6()),
            ChatMessage(text: Strings.guideMessage7()),
            ChatMessage(text: Strings.guideMessage8()),
            ChatMessage(text: Strings.guideMessage9()),
            ChatMessage(text: Strings.guideMessage10()),
            ChatMessage(text: Strings.guideMessage11()),
            ChatMessage(text: Strings.guideMessage12()),
            ChatMessage(text: Strings.guideMessage13()),
            ChatMessage(text: Strings.guideMessage14()),
            ChatMessage(text: Strings.guideMessage15()),
            ChatMessage(text: Strings.guideMessage16())
    ]
    
    private var sections: [[ChatMessage]] = [[]]
    private let configurator = GuideChatConfigurator()
    private var collectionView = ChatCollectionView(sections: [[]])
    private let itemHeight: CGFloat = 110
    
    private var collectionBottonConstraint: NSLayoutConstraint?
    private var collectionButtonConstraint: NSLayoutConstraint?
    private var collectionTopConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(guideChatViewController: self)
        
        presenter?.viewDidLoad()
        
        addCollectionView()
        configureTopView()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showNextButton(false)
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.flowLayout.itemSize = CGSize(width: view.bounds.size.width - 50, height: itemHeight)
        collectionView.flowLayout.minimumLineSpacing = 20
        collectionView.flowLayout.minimumInteritemSpacing = 0
        collectionView.flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        sections[0].append(ChatMessage(text: Strings.guideMessage1()))
        updateCollectionView()

        startTimer()
                
        startActivityViewAnimation()
        
        if !isAnimationRunning {
            isAnimationRunning = true
        }
    }
    
    private func configureTopView() {
        topView.addShadow(alpha: 0.15, yOffset: 4, blur: 25)
    }
    
    private func showNextButton(_ show: Bool) {
        nextButton.isHidden = !show
        nextButtonHeightConstraint.constant = show ? 44 : 0
        view.layoutIfNeeded()
    }
    
    func set(typingLabelText: String) {
        typingLabel.text = typingLabelText
    }
    
    private func startActivityViewAnimation() {
        var animationDelay = 0.0
        let delayTimePoints = [0.12, 0.24, 0.36]
        
        for dotViewIndex in 0..<dotsStack.arrangedSubviews.count {
            let dotView = dotsStack.arrangedSubviews[dotViewIndex]

            animationDelay += delayTimePoints[dotViewIndex]
            UIView.animate(withDuration: 0.5, delay: animationDelay, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
                dotView.transform = CGAffineTransform(scaleX: 2, y: 2)
            })
        }
    }
    
    func set(nextButtonTitle: String) {
        nextButton.setTitle(nextButtonTitle, for: .normal)
    }
                
    private func addCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(collectionView, at: 0)

        collectionTopConstraint = collectionView.topAnchor.constraint(equalTo: topView.bottomAnchor)
        collectionTopConstraint?.isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionBottonConstraint = collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        collectionBottonConstraint?.isActive = true
        collectionButtonConstraint = collectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -50)
        collectionButtonConstraint?.isActive = false
        
        collectionView.register(UINib(nibName: ChatCell.id, bundle: .main), forCellWithReuseIdentifier: ChatCell.id)
    }
        
    private func startTimer() {
        let chatMessageDelay = TimeInterval(Config.shared.chatMessageDelay() ?? 4)
        
        timer = Timer.scheduledTimer(withTimeInterval: chatMessageDelay, repeats: true) { (_) in
            let indexForNewMessage = self.sections[0].count - 1
            
            guard indexForNewMessage < self.messagesToShow.count else { return }
            
            let newMessage = self.messagesToShow[indexForNewMessage]
            self.sections[0].append(newMessage)
                        
            if indexForNewMessage >= self.messagesToShow.count - 1 {
                self.isTyping(false)
                self.timer?.invalidate()
                self.showNextButton(true)
                self.collectionBottonConstraint?.isActive = false
                self.collectionButtonConstraint?.isActive = true
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                })
            }
            
            self.updateCollectionView()
        }
    }
    
    private func updateCollectionView() {
        collectionView.sections = sections
        
        let delay = sections[0].count == 1 ? 1.0 : 0
        
        UIView.animate(withDuration: 0.3, delay: delay, options: .curveEaseOut, animations: {
            self.collectionView.performBatchUpdates({
                let nextIndexPath = IndexPath(item: self.sections[0].count - 1, section: 0)
                self.collectionView.insertItems(at: [nextIndexPath])
            }, completion: { _ in
                self.scrollToLastMessage()
            })
        }, completion: { _ in })
    }
    
    private func scrollToLastMessage() {
        collectionView.scrollToItem(at: IndexPath(item: sections[0].count - 1, section: 0), at: .bottom, animated: true)
    }
    
    @IBAction func gotItButtonTapped(_ sender: Any) {
        presenter?.didTapGotItButton()
    }
    
    private func isTyping(_ isTyping: Bool) {
        dotsStack.isHidden = !isTyping
        typingLabel.text = Strings.guideOnline()
    }
}
