//
//  AddressAutocompleteTableViewCell.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 08/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import UIKit

final class AddressAutoCompleteTableViewCell: UITableViewCell {
    private let titleLabel: UILabel
    var viewModel: AddressAutoCompleteCellViewModel? {
        didSet { self.bind() }
    }
    
    // MARK: Initializers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.titleLabel = UILabel()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.viewModel = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.width
        super.layoutSubviews()
    }
    
    // MARK: Setup
    
    private func setupView() {
        contentView.addSubview(titleLabel)
        setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        let topConstraint = titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0)
        let bottomConstraint = titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0)
        let leftConstraint = titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0)
        let rightConstraint = titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0)
        NSLayoutConstraint.activate([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }
    
    // MARK: Binding
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.formattedAddress
    }
}
