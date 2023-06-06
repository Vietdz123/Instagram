//
//  SelectedSettingProfileController.swift
//  Instagram
//
//  Created by Long Bảo on 18/05/2023.
//

import UIKit


class SettingProfileController: BottomSheetViewCustomController {
    //MARK: - Properties
    let containerView = UIView()
    let tableView = UITableView(frame: .zero, style: .plain)
    
    override var heightBottomSheetView: CGFloat {
        return 500
    }
    
    override var maxHeightScrollTop: CGFloat {
        return 50
    }
    
    override var minHeightScrollBottom: CGFloat {
        return 120
    }
    
    override var maxVeclocity: CGFloat {
        return 900
    }

    override var bottomSheetView: UIView {
        return containerView
    }
    
    private let scrollDivider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        view.setDimensions(width: 36, height: 4)
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureProperties()
    }
    
    deinit {
        print("DEBUG: SelectTypePhotoController deinit")
    }
    
    //MARK: - Helpers
    func configureProperties() {
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(SelectedTypeTableViewCell.self,
                           forCellReuseIdentifier: SelectedTypeTableViewCell.identifier)
        
    }
    
    func configureUI() {
        containerView.backgroundColor = .systemBackground
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 25
        containerView.addSubview(tableView)
        containerView.addSubview(scrollDivider)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollDivider.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            scrollDivider.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: scrollDivider.bottomAnchor, constant: 9),
            tableView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
extension SettingProfileController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SelectedSettingProfileType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectedTypeTableViewCell.identifier, for: indexPath) as! SelectedTypeTableViewCell
        cell.dataTypeSettingProfile = SelectedSettingProfileType(rawValue: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.animationDismiss()
    }
    
}
