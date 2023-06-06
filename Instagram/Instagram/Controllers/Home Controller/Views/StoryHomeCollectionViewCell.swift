//
//  StoryHomeCollectionViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 14/05/2023.
//

import UIKit

class StoryHomeCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "StoryHomeCollectionViewCell"
    var imageStory: UIImage? {
        didSet {
            self.storyImageView.image = imageStory
        }
    }
    
    var storyLayer: InstagramStoryLayer!
    var isRunningAnimationStory = false

    private lazy var storyImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .red
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 58 / 2
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageStoryTapped)))
        iv.isUserInteractionEnabled = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
     lazy var plusStoryImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "plus.circle.fill"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .systemBlue
        iv.layer.borderWidth = 5.3
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 32 / 2
        iv.backgroundColor = .white
        iv.isHidden = true
        return iv
    }()
    
     lazy var storyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tin nổi bật"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        addSubview(storyImageView)
        addSubview(storyLabel)
        addSubview(plusStoryImageView)
        
        NSLayoutConstraint.activate([
            storyImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            storyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            storyImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12),
            storyImageView.heightAnchor.constraint(equalTo: storyImageView.widthAnchor),
            
            storyLabel.topAnchor.constraint(equalTo: storyImageView.bottomAnchor, constant: 5.8),
            storyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            storyLabel.leftAnchor.constraint(equalTo: leftAnchor),
            storyLabel.rightAnchor.constraint(equalTo: rightAnchor),
            
            plusStoryImageView.bottomAnchor.constraint(equalTo: storyImageView.bottomAnchor, constant: 8),
            plusStoryImageView.rightAnchor.constraint(equalTo: storyImageView.rightAnchor, constant: 8)
        ])
        plusStoryImageView.setDimensions(width: 32, height: 32)
        
        layoutIfNeeded()
        self.storyLayer = InstagramStoryLayer(centerPoint: CGPoint(x: storyImageView.frame.midX,
                                                                   y: storyImageView.frame.midY),
                                              width: self.storyImageView.bounds.width + 10,
                                              lineWidth: 2.35)
        layer.addSublayer(storyLayer)

    }
    
    //MARK: - Selectors
    @objc func handleImageStoryTapped() {
        if !isRunningAnimationStory {
            self.storyLayer.startAnimation()
        } else {
            self.storyLayer.stopAnimation()
        }
        
        isRunningAnimationStory = !isRunningAnimationStory

    }
    
}
//MARK: - delegate


