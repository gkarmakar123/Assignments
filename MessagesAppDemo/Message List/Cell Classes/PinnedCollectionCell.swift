//
//  PinnedCollectionCell.swift
//  MessagesAppDemo
//
//  Created by Gaurav Karmakar on 14/02/21.
//

import UIKit

protocol PinnedCollectionCellDelegate {
    func unPinButtonTapped(for pinnedCell: PinnedCollectionCell)
}

class PinnedCollectionCell: UICollectionViewCell {
    static let reuseIdentifier = "PinnedCollectionCell"
    
    var delegate: PinnedCollectionCellDelegate?
    
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
        theSenderImageView.image = #imageLiteral(resourceName: "avatar")
        theSenderImageView.backgroundColor = .gray
        theSenderImageView.clipsToBounds = true
        return theSenderImageView
    }()
    
    private lazy var senderNameLabel: UILabel = {
        let theSenderNameLabel = UILabel()
        theSenderNameLabel.translatesAutoresizingMaskIntoConstraints = false
        theSenderNameLabel.textColor = .systemGray
        theSenderNameLabel.font = Constants.PinnedCell.senderNameFont

        return theSenderNameLabel
    }()

    private lazy var unPinButton: UIButton = {
        let theUnPinButton = UIButton(type: .custom)
        theUnPinButton.translatesAutoresizingMaskIntoConstraints = false
        theUnPinButton.setBackgroundImage(#imageLiteral(resourceName: "minus").withTintColor(.red), for: .normal)
        theUnPinButton.backgroundColor = .clear
        theUnPinButton.contentEdgeInsets = UIEdgeInsets(top: -5.0, left: -5.0, bottom: -5.0, right: -5.0)
        
        theUnPinButton.addAction(UIAction(handler: { [unowned self] sender in
            self.delegate?.unPinButtonTapped(for: self)
        }), for: .touchUpInside)
        
        return theUnPinButton
    }()
    
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
extension PinnedCollectionCell {
    
    private func setupUI() {
        addSubview(unreadStatusDot)
        addSubview(senderImageView)
        addSubview(senderNameLabel)
        addSubview(unPinButton)
    }
    
    private func setupConstraints() {
        
        let senderImageViewDiameter = Constants.PinnedCell.itemWidth()
        
        NSLayoutConstraint.activate([
            senderImageView.widthAnchor.constraint(
                equalToConstant: CGFloat(senderImageViewDiameter)),
            senderImageView.heightAnchor.constraint(
                equalToConstant: CGFloat(senderImageViewDiameter)),
            senderImageView.centerXAnchor.constraint(
                equalTo: self.centerXAnchor),
            senderImageView.topAnchor.constraint(
                equalTo: self.topAnchor),
            
            senderNameLabel.topAnchor.constraint(
                equalTo: senderImageView.bottomAnchor,
                constant: 10.0),
            senderNameLabel.centerXAnchor.constraint(
                equalTo: senderImageView.centerXAnchor),

            unreadStatusDot.widthAnchor.constraint(
                equalToConstant: Constants.unreadDotImageDiameter),
            unreadStatusDot.heightAnchor.constraint(
                equalTo: unreadStatusDot.widthAnchor),
            unreadStatusDot.centerYAnchor.constraint(
                equalTo: senderNameLabel.centerYAnchor),
            unreadStatusDot.trailingAnchor.constraint(
                equalTo: senderNameLabel.leadingAnchor,
                constant: -5.0),
                        
            unPinButton.heightAnchor.constraint(equalToConstant: 20.0),
            unPinButton.widthAnchor.constraint(equalToConstant: 20.0),
            unPinButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10.0),
            unPinButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -35.0),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        unreadStatusDot.layer.cornerRadius = unreadStatusDot.frame.size.width/2
        senderImageView.layer.cornerRadius = senderImageView.frame.size.width/2
    }
}

//MARK:- Loading cell with data
extension PinnedCollectionCell {
    public func loadCell(with messageModel: MessageModel) {
        unreadStatusDot.isHidden = !messageModel.lastMessageUnread
        
        senderNameLabel.text = messageModel.senderName
        
        unPinButton.isHidden = !messageModel.inEditMode
        
        if messageModel.inEditMode {
            let transformAnim  = CAKeyframeAnimation(keyPath:"transform")
            transformAnim.values  = [
                NSValue(caTransform3D: CATransform3DMakeRotation(0.03, 0.0, 0.0, 1.0)),
                NSValue(caTransform3D: CATransform3DMakeRotation(-0.03 , 0.0, 0.0, 1.0))
            ]
            transformAnim.autoreverses = true
            transformAnim.duration  = 0.215
            transformAnim.repeatCount = Float.infinity
            self.layer.add(transformAnim, forKey: "transform")
        }
    }
}
