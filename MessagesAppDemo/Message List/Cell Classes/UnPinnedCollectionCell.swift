//
//  UnPinnedCollectionCell.swift
//  MessagesAppDemo
//
//  Created by Gaurav Karmakar on 14/02/21.
//

import UIKit

protocol UnPinnedCollectionCellDelegate {
    func pinButtonTapped(for unPinnedCell: UnPinnedCollectionCell)
}

class UnPinnedCollectionCell: UICollectionViewListCell {//UICollectionViewListCell {
    static let reuseIdentifier = "UnPinnedCollectionCell"
    
    var delegate: UnPinnedCollectionCellDelegate?
    
    //MARK:- Subviews
    private lazy var unreadStatusDot: UIView = {
       let theUnreadStatusDot = UIView()
        theUnreadStatusDot.translatesAutoresizingMaskIntoConstraints = false
        theUnreadStatusDot.backgroundColor = Constants.unreadDotColor
        
        return theUnreadStatusDot
    }()
    
    private lazy var senderImageView: UIImageView = {
       let theSenderImageView = UIImageView()
        theSenderImageView.translatesAutoresizingMaskIntoConstraints = false
        theSenderImageView.clipsToBounds = true
        theSenderImageView.image = #imageLiteral(resourceName: "avatar")
        theSenderImageView.backgroundColor = .gray
        return theSenderImageView
    }()
    
    private lazy var senderNameLabel: UILabel = {
        let theSenderNameLabel = UILabel()
        theSenderNameLabel.translatesAutoresizingMaskIntoConstraints = false
        theSenderNameLabel.textColor = .black
        theSenderNameLabel.font = Constants.UnPinnedCell.senderNameFont
        theSenderNameLabel.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        return theSenderNameLabel
    }()

    private lazy var lastMessageLabel: UILabel = {
        let theLastMessageLabel = UILabel()
        theLastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        theLastMessageLabel.textColor = .systemGray
        theLastMessageLabel.font = Constants.UnPinnedCell.lastMessageFont
        theLastMessageLabel.numberOfLines = 2
        theLastMessageLabel.lineBreakMode = .byTruncatingTail
        
        return theLastMessageLabel
    }()

    private lazy var messageDateLabel: UILabel = {
        let theMessageDateLabel = UILabel()
        theMessageDateLabel.translatesAutoresizingMaskIntoConstraints = false
        theMessageDateLabel.textColor = .systemGray
        theMessageDateLabel.font = Constants.UnPinnedCell.messageDateFont
        theMessageDateLabel.setContentCompressionResistancePriority((.defaultHigh + 1), for: .horizontal)
        theMessageDateLabel.setContentHuggingPriority((.defaultHigh + 1), for: .horizontal)
        
        return theMessageDateLabel
    }()
    
    private lazy var arrowImageView: UIImageView = {
       let theArrowImageView = UIImageView()
        theArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        theArrowImageView.image = #imageLiteral(resourceName: "arrow").withTintColor(.systemGray)
        
        return theArrowImageView
    }()

    private lazy var pinButton: UIButton = {
        let thePinButton = UIButton(type: .custom)
        thePinButton.translatesAutoresizingMaskIntoConstraints = false
        thePinButton.setBackgroundImage(#imageLiteral(resourceName: "paper-push-pin").withTintColor(.red), for: .normal)
        thePinButton.backgroundColor = .white
        thePinButton.contentEdgeInsets = UIEdgeInsets(top: -5.0, left: -5.0, bottom: -5.0, right: -5.0)
        
        thePinButton.addAction(UIAction(handler: { [unowned self] sender in
            self.delegate?.pinButtonTapped(for: self)
        }), for: .touchUpInside)
        
        return thePinButton
    }()
    
    var pinButtonTrailingConstraint: NSLayoutConstraint!

    //MARK:-
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK:- Setting up UI for cell
extension UnPinnedCollectionCell {
    
    private func setupUI() {
        addSubview(unreadStatusDot)
        addSubview(senderImageView)
        addSubview(senderNameLabel)
        addSubview(lastMessageLabel)
        addSubview(messageDateLabel)
        addSubview(arrowImageView)
        addSubview(pinButton)
        //self.accessories = [.disclosureIndicator()]
    }
       
    private func setupConstraints() {
        separatorLayoutGuide.leadingAnchor.constraint(equalTo: senderNameLabel.leadingAnchor).isActive = true

        NSLayoutConstraint.activate([
            unreadStatusDot.widthAnchor.constraint(
                equalToConstant: Constants.unreadDotImageDiameter),
            unreadStatusDot.heightAnchor.constraint(
                equalTo: unreadStatusDot.widthAnchor),
            unreadStatusDot.centerYAnchor.constraint(
                equalTo: self.centerYAnchor),
            unreadStatusDot.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: 10.0),
            
            senderImageView.widthAnchor.constraint(
                equalToConstant: Constants.UnPinnedCell.senderImageDiameter),
            senderImageView.heightAnchor.constraint(
                equalTo: senderImageView.widthAnchor),
            senderImageView.centerYAnchor.constraint(
                equalTo: self.centerYAnchor),
            senderImageView.leadingAnchor.constraint(
                equalTo: unreadStatusDot.trailingAnchor,
                constant: 10.0),
            self.bottomAnchor.constraint(greaterThanOrEqualTo: senderImageView.bottomAnchor, constant: 10.0),
            
            senderNameLabel.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: 10.0),
            senderNameLabel.leadingAnchor.constraint(
                equalTo: senderImageView.trailingAnchor,
                constant: 10.0),
            senderNameLabel.trailingAnchor.constraint(
                equalTo: messageDateLabel.leadingAnchor,
                constant: -5.0),
            
            lastMessageLabel.topAnchor.constraint(
                equalTo: senderNameLabel.bottomAnchor,
                constant: 5.0),
            lastMessageLabel.leadingAnchor.constraint(
                equalTo: senderNameLabel.leadingAnchor),
            lastMessageLabel.trailingAnchor.constraint(
                equalTo: arrowImageView.trailingAnchor),
//            lastMessageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20.0),
            self.bottomAnchor.constraint(equalTo: lastMessageLabel.bottomAnchor, constant: 10.0),
            
            messageDateLabel.centerYAnchor.constraint(
                equalTo: senderNameLabel.centerYAnchor),
            messageDateLabel.trailingAnchor.constraint(
                equalTo: arrowImageView.leadingAnchor,
                constant: -20.0),

            arrowImageView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: -20.0),
            arrowImageView.centerYAnchor.constraint(
                equalTo: messageDateLabel.centerYAnchor),
            arrowImageView.heightAnchor.constraint(
                equalToConstant: CGFloat(16.0)),
            arrowImageView.widthAnchor.constraint(
                equalTo: arrowImageView.heightAnchor, multiplier: 0.625),
            
            pinButton.heightAnchor.constraint(equalToConstant: 20.0),
            pinButton.widthAnchor.constraint(equalToConstant: 20.0),
            pinButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
        
        pinButtonTrailingConstraint = pinButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 50.0)
        pinButtonTrailingConstraint.isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        unreadStatusDot.layer.cornerRadius = unreadStatusDot.frame.size.width/2
        senderImageView.layer.cornerRadius = senderImageView.frame.size.width/2
    }
}

//MARK:- Loading cell with data
extension UnPinnedCollectionCell {
    public func loadCell(with messageModel: MessageModel) {
        unreadStatusDot.isHidden = !messageModel.lastMessageUnread
        
        //TODO - Load image
        if let imageURL = URL(string: messageModel.senderImageURL) {
//            senderImageView.image = UIImage(contentsOfFile: messageModel.senderImageURL)
        }
        senderNameLabel.text = messageModel.senderName
        lastMessageLabel.text = messageModel.lastMessage
        messageDateLabel.text = messageModel.lastMessageDate
        
        if messageModel.inEditMode == false {
            messageDateLabel.isHidden = false
            arrowImageView.isHidden = false
            pinButton.isHidden = true
            pinButtonTrailingConstraint.constant = 50.0
        } else {
            self.messageDateLabel.isHidden = true
            self.arrowImageView.isHidden = true
            pinButton.isHidden = false
            pinButtonTrailingConstraint.constant = -20.0
        }
    }
}
