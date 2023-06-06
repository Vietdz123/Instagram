//
//  BottomControllerVer2.swift
//  Instagram
//
//  Created by Long Bảo on 30/05/2023.
//

import UIKit

struct TitleLabel {
    var font: UIFont
    var titleColor: UIColor
    var title: String
    
    init(title: String,
         font: UIFont = .systemFont(ofSize: 14, weight: .semibold),
         titleColor: UIColor = .label) {
        self.title = title
        self.font = font
        self.titleColor = titleColor
    }
}

struct TitleImage {
    var image: UIImage?
    var tinColor: UIColor
    var size: CGSize
    
    init(image: UIImage?,
         size: CGSize = CGSize(width: 25, height: 25),
         tinColor: UIColor = .label) {
        self.image = image
        self.tinColor = tinColor
        self.size = size
    }
}

struct TitleTabStripBottom {
    var titleString: TitleLabel = TitleLabel(title: "")
    var titleImage: TitleImage?
    
    init(titleString: TitleLabel) {
        self.titleString = titleString
    }
    
    init(titleImage: TitleImage) {
        self.titleImage = titleImage
    }
}

class BottomController: UIViewController {
    //MARK: - Properties
    var bottomTabTripCollectionView: UICollectionView {
        fatalError("User must override bottomTabTripCollectionView this property")
    }
    
    var titleBottom: TitleTabStripBottom
    
    init(titleBottom: TitleTabStripBottom) {
        self.titleBottom = titleBottom
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - View Lifecycle

    deinit {
        print("DEBUG: BottomController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}




