//
//  SelectedTypeTableViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 18/05/2023.
//

import UIKit

struct SelectedTypeCellData {
    let title: String
    let image: UIImage?
}

enum SelectedSettingProfileType: Int, CaseIterable {
    case rays
    case sunmaxfill
    case clockarrowcirclepath
    case qrcode
    case bookmarkfill
    case creditcard
    case liststar
    case star
    
    var description: String {
        switch self {
        case .rays:
            return "Setting"
        case .sunmaxfill:
            return "Your activity"
        case .clockarrowcirclepath:
            return "Archive"
        case .qrcode:
            return "QR Code"
        case .bookmarkfill:
            return "Saved"
        case .creditcard:
            return "Orders and Payments"
        case .liststar:
            return "Close Friend"
        case .star:
            return "Favorites"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .rays:
            return UIImage(systemName: "rays")
        case .sunmaxfill:
            return UIImage(systemName: "sun.max.fill")
        case .clockarrowcirclepath:
            return UIImage(systemName: "clock.arrow.circlepath")
        case .qrcode:
            return UIImage(systemName: "qrcode")
        case .bookmarkfill:
            return UIImage(systemName: "bookmark")
        case .creditcard:
            return UIImage(systemName: "creditcard")
        case .liststar:
            return UIImage(systemName: "list.star")
        case .star:
            return UIImage(systemName: "star")
        }
    }
}


class SelectedTypeTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "SelectedTypeTableViewCell"
    var dataTypeEditProfile: SelectedTypeCellData? {
        didSet {
            updateUISelectedPhotoTypeCell()
        }
    }
    
    var dataTypeSettingProfile: SelectedSettingProfileType? {
        didSet {
            updateUISelectedSettingProfileCell()
        }
    }

    private lazy var typePhotoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "camera"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.tintColor = .label
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        label.text = "Chọn thư viện ảnh"
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        view.isHidden = true
        view.alpha = 0.4
        return view
    }()
    
    //MARK: - View Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        self.activeConstraint()
    }
    
    func activeConstraint() {
        backgroundColor = .systemBackground
        contentView.addSubview(typePhotoImageView)
        contentView.addSubview(mainLabel)
        contentView.addSubview(divider)
        contentView.addSubview(divider)
        
        NSLayoutConstraint.activate([
            typePhotoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            typePhotoImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            typePhotoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            mainLabel.centerYAnchor.constraint(equalTo: typePhotoImageView.centerYAnchor),
            mainLabel.leftAnchor.constraint(equalTo: typePhotoImageView.rightAnchor, constant: 17),
            mainLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            divider.leftAnchor.constraint(equalTo: mainLabel.leftAnchor, constant: -4),
            divider.rightAnchor.constraint(equalTo: rightAnchor)
        ])

        typePhotoImageView.setDimensions(width: 30, height: 25)
    }
    
    func updateUISelectedPhotoTypeCell() {
        self.mainLabel.text = self.dataTypeEditProfile?.title
        self.typePhotoImageView.image = self.dataTypeEditProfile?.image
    }
    
    func updateUISelectedSettingProfileCell() {
        self.mainLabel.text = self.dataTypeSettingProfile?.description
        self.typePhotoImageView.image = self.dataTypeSettingProfile?.image
        self.divider.isHidden = false
    }
    //MARK: - Selectors

    
}
//MARK: - delegate

