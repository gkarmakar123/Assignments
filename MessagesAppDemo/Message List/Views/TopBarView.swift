//
//  TopBarView.swift
//  MessagesAppDemo
//
//  Created by Gaurav Karmakar on 14/02/21.
//

import UIKit

protocol TopBarViewDelegate {
    func editButtonTapped()
    func doneButtonTapped()
}

final class TopBarView: UIView {

    var delegate: TopBarViewDelegate?
    
    private lazy var titleLabel: UILabel = {
        let theLabel = UILabel()
        theLabel.translatesAutoresizingMaskIntoConstraints = false
        theLabel.text = "Messages"
        theLabel.textColor = .black
        theLabel.font = UIFont.boldSystemFont(ofSize: 24.0)
        
        return theLabel
    }()
    
    private lazy var editButton: UIButton = {
        let theEditButton = UIButton(type: .custom)
        theEditButton.translatesAutoresizingMaskIntoConstraints = false
        theEditButton.setBackgroundImage(#imageLiteral(resourceName: "pen_icon"), for: .normal)
        
        theEditButton.addAction(UIAction(handler: { [unowned self] action in
            theEditButton.isHidden = true
            self.doneButton.isHidden = false
            
            self.delegate?.editButtonTapped()
        }), for: .touchUpInside)
        
        return theEditButton
    }()
    
    private lazy var doneButton: UIButton = {
        let theDoneButton = UIButton(type: .custom)
        theDoneButton.translatesAutoresizingMaskIntoConstraints = false
        theDoneButton.setTitle("Done", for: .normal)
        theDoneButton.setTitleColor(Constants.unreadDotColor, for: .normal)
        theDoneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22.0)
        theDoneButton.addAction(UIAction(handler: { [unowned self] action in
            self.editButton.isHidden = false
            theDoneButton.isHidden = true

            self.delegate?.doneButtonTapped()
        }), for: .touchUpInside)

        return theDoneButton
    }()

    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        applyAccessibility()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(editButton)
        addSubview(doneButton)
        doneButton.isHidden = true
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            editButton.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                               constant: -Constants.edgeInset),
            editButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            editButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45, constant: 0.0),
            editButton.widthAnchor.constraint(equalTo: editButton.heightAnchor),
            
            doneButton.trailingAnchor.constraint(equalTo: editButton.trailingAnchor),
            doneButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            doneButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45, constant: 0.0),
//            doneButton.widthAnchor.constraint(equalTo: editButton.heightAnchor)

        ])
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

//MARK:- Accessibility setup
extension TopBarView {
    func applyAccessibility() {
        titleLabel.font = .preferredFont(forTextStyle: .body)
        titleLabel.adjustsFontForContentSizeCategory = true

        editButton.accessibilityLabel = "Edit Icon"
        editButton.accessibilityHint = "Makes the complete list editable"
    }
}
