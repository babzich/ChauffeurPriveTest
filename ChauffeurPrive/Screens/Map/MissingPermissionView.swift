//
//  MissingPermissionView.swift
//  ChauffeurPrive
//
//  Created by Vincent Bach on 06/02/2017.
//  Copyright © 2017 Vincent Bach. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MissingPermissionView: UIView {
    private let titleLabel: UILabel
    private let descriptionLabel: UILabel
    private let openPreferencesButton: UIButton
    
    private let viewModel: MissingPermissionViewModel
    private let disposeBag: DisposeBag
    
    // MARK: Initializers
    
    init(viewModel: MissingPermissionViewModel) {
        self.titleLabel = UILabel(frame: .zero)
        self.descriptionLabel = UILabel(frame: .zero)
        self.openPreferencesButton = UIButton()
        self.viewModel = viewModel
        self.disposeBag = DisposeBag()
        
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Setup
    
    private func setupView() {
        [titleLabel, descriptionLabel, openPreferencesButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        setupTitleLabel()
        setupDescriptionLabel()
        setupPreferencesButton()
    }
    
    private func setupTitleLabel() {
        titleLabel.font = Font.System.semiBold.of(size: 22.0)
        titleLabel.textColor = Color.white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = viewModel.title
        
        let leftConstraint = titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0)
        let rightConstraint = titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0)
        let topConstraint = titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 150.0)
        NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint])
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.font = Font.System.regular.of(size: 14.0)
        descriptionLabel.textColor = Color.white
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = viewModel.description
        
        let leftConstraint = descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0)
        let rightConstraint = descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0)
        let topConstraint = descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20.0)
        NSLayoutConstraint.activate([leftConstraint, rightConstraint, topConstraint])
    }
    
    private func setupPreferencesButton() {
        openPreferencesButton.titleLabel?.font = Font.System.regular.of(size: 16.0)
        openPreferencesButton.setTitleColor(Color.white, for: .normal)
        openPreferencesButton.setTitle(viewModel.actionButtonText.uppercased(), for: .normal)
        openPreferencesButton.layer.borderColor = Color.white.cgColor
        openPreferencesButton.layer.borderWidth = 1.0
        
        let topConstraint = openPreferencesButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20.0)
        let leftConstraint = openPreferencesButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20.0)
        let rightConstraint = openPreferencesButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20.0)
        let heightConstraint = openPreferencesButton.heightAnchor.constraint(equalToConstant: 40.0)
        NSLayoutConstraint.activate([topConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        openPreferencesButton.rx.tap
            .bindNext { [weak self] in self?.openSystemPreferences() }
            .disposed(by: disposeBag)
    }
    
    // MARK: Actions
    
    private func openSystemPreferences() {
        guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else { return }
        UIApplication.shared.openURL(settingsURL)
    }
}
