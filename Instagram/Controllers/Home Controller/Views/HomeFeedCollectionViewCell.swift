//
//  HomeFeedCollectionViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 14/05/2023.
//


import UIKit
import SDWebImage

protocol HomeFeedCollectionViewCellDelegate: AnyObject {
    func didSelectAvatar(status: StatusModel)
    func didSelectNumberLikesButton(status: StatusModel)
    func didSelectCommentButton(cell: HomeFeedCollectionViewCell, status: StatusModel)
    func updateCell(indexPath: IndexPath?)
}

extension HomeFeedCollectionViewCellDelegate {
    func updateCell(indexPath: IndexPath?) {}
}

class HomeFeedCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    private var heightImageConstraint: NSLayoutConstraint!
    static let identifier = "HomeFeedCollectionViewCell"
    private var actionBar: NavigationCustomView!
    weak var delegate: HomeFeedCollectionViewCellDelegate?
    var indexPath: IndexPath?
    var viewModel: HomeFeedCellViewModel? {
        didSet {
            updateUI()
            viewModel?.hasLikedStatus()
            viewModel?.fetchNumberUsersLikedStatus()
            viewModel?.fetchNumberUsersCommented()
            updateLikeAndCommentButton()
        }
    }
    
    private lazy var avatarUserUpTusImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .blue
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 36 / 2
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                       action: #selector(handleAvatarImageTapped)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "black_pink"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                          action: #selector(handleAvatarImageTapped)))
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private lazy var photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        iv.addSubview(heardLikemageView)
        NSLayoutConstraint.activate([
            heardLikemageView.centerXAnchor.constraint(equalTo: iv.centerXAnchor),
            heardLikemageView.centerYAnchor.constraint(equalTo: iv.centerYAnchor),
        ])
        heardLikemageView.setDimensions(width: 33, height: 25)
        let tapGeture = UITapGestureRecognizer(target: self,
                                               action: #selector(handelDoubleTapPhotoImageView))
        tapGeture.numberOfTapsRequired = 2
        iv.addGestureRecognizer(tapGeture)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var heardLikemageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "heart.fill"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.isHidden = true
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.tintColor = .white
        return iv
    }()
    
    private lazy var numberLikesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(handleNumberLikeButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var statusLabel: UILabel = Utilites.createStatusFeedLabel(username: "",
                                                                           status: "")
    
    private lazy var allCommentsButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.addTarget(self, action: #selector(handelAllCommentButtonTapped), for: .touchUpInside)
        button.setTitleColor(.gray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        return button
    }()
    
    private lazy var actionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [numberLikesButton, statusLabel, allCommentsButton])
        stackView.spacing = 1
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let timePostTusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    //MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    deinit {
        SDImageCache.shared.clearMemory()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        self.setupNavigationBar()
        addSubview(avatarUserUpTusImageView)
        addSubview(usernameLabel)
        addSubview(photoImageView)
        addSubview(actionBar)
        addSubview(actionStackView)
        addSubview(timePostTusLabel)
        
        heightImageConstraint = photoImageView.heightAnchor.constraint(equalToConstant: 500)
        let bottomAnchor =  timePostTusLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottomAnchor.priority = UILayoutPriority(999)

        NSLayoutConstraint.activate([
            avatarUserUpTusImageView.topAnchor.constraint(equalTo: topAnchor),
            avatarUserUpTusImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 11),
            
            usernameLabel.centerYAnchor.constraint(equalTo: avatarUserUpTusImageView.centerYAnchor),
            usernameLabel.leftAnchor.constraint(equalTo: avatarUserUpTusImageView.rightAnchor, constant: 9),
            
            photoImageView.topAnchor.constraint(equalTo: avatarUserUpTusImageView.bottomAnchor, constant: 7),
            photoImageView.leftAnchor.constraint(equalTo: leftAnchor),
            photoImageView.widthAnchor.constraint(equalTo: widthAnchor),
            heightImageConstraint,
            
            actionBar.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 9),
            actionBar.leftAnchor.constraint(equalTo: leftAnchor),
            actionBar.rightAnchor.constraint(equalTo: rightAnchor),
            actionBar.heightAnchor.constraint(equalToConstant: 35),
            
            actionStackView.topAnchor.constraint(equalTo: actionBar.bottomAnchor, constant: 2),
            actionStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),

            timePostTusLabel.topAnchor.constraint(equalTo: actionStackView.bottomAnchor),
            timePostTusLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            timePostTusLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            bottomAnchor,
        ])
        avatarUserUpTusImageView.setDimensions(width: 36, height: 36)
        actionStackView.setContentHuggingPriority(UILayoutPriority(751), for: .vertical)
        actionStackView.setContentCompressionResistancePriority(UILayoutPriority(751), for: .vertical)
        timePostTusLabel.setContentHuggingPriority(UILayoutPriority(752), for: .vertical)
        timePostTusLabel.setContentCompressionResistancePriority(UILayoutPriority(752), for: .vertical)
    }
    
    func setupNavigationBar() {
        let attributeFirstLeftButton = AttibutesButton(image: UIImage(named: "like1"),
                                                       sizeImage: CGSize(width: 25, height: 25)) { [weak self] in
            self?.didTapLikeButton()
        }
                                                   
        let attributeSecondLeftButton = AttibutesButton(image: UIImage(named: "comment-1"),
                                                        sizeImage: CGSize(width: 25, height: 25)) { [weak self] in
            self?.delegate?.didSelectCommentButton(cell: self!, status: self!.viewModel!.status)
        }
                                                        
        let attributeThreeLeftButton = AttibutesButton(image: UIImage(named: "share"),
                                                  sizeImage: CGSize(width: 29, height: 29))
        
        let attributeFirstRightButton = AttibutesButton(image: UIImage(named: "Bookmark"),
                                                  sizeImage: CGSize(width: 34, height: 31))
                                                   
        self.actionBar = NavigationCustomView(attributeLeftButtons: [attributeFirstLeftButton,
                                                                    attributeSecondLeftButton,
                                                                    attributeThreeLeftButton],
                                              attributeRightBarButtons: [attributeFirstRightButton],
                                              isHiddenDivider: true,
                                              beginSpaceLeftButton: 15,
                                              beginSpaceRightButton: 15,
                                              continueSpaceleft: 15)
    }
    
    func updateLikeAndCommentButton() {
        self.viewModel?.completionLike = { [weak self] in
            self?.updateLikeButton()
        }
        
        self.viewModel?.completionFetchNumberLikes = { [weak self] in
            self?.numberLikesButton.setTitle(self?.viewModel?.numberLikesString, for: .normal)
//            self?.numberLikesButton.isHidden = self?.viewModel?.isHiddedNumberLike ?? false
        }
        
        self.viewModel?.completionFetchNumberUserCommented = { [weak self] in
            self?.allCommentsButton.setTitle(self?.viewModel?.numberCommmentsString, for: .normal)
        }
    }
    
    func updateUI() {
        NSLayoutConstraint.deactivate([heightImageConstraint])
        guard let viewModel = viewModel else {
            return
        }
        numberLikesButton.isHidden = false
        allCommentsButton.isHidden = false

        let ratio: CGFloat = viewModel.ratioImage
        heightImageConstraint = self.photoImageView.heightAnchor.constraint(equalTo: self.photoImageView.widthAnchor, multiplier: ratio)
        NSLayoutConstraint.activate([
            heightImageConstraint,
        ])
        
        avatarUserUpTusImageView.sd_setImage(with: viewModel.avatarURL,
                                             placeholderImage: UIImage(systemName: "person.circle"))
        photoImageView.sd_setImage(with: viewModel.photoURL)
        usernameLabel.text = viewModel.username
        
        if viewModel.haveCaption {
            statusLabel.attributedText = viewModel.attributedCaptionLabel
            statusLabel.isHidden = false
            statusLabel.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                    action: #selector(handelAllCommentButtonTapped)))
            statusLabel.isUserInteractionEnabled = true
        } else {
            statusLabel.isHidden = true
        }
        
        
        self.timePostTusLabel.text = viewModel.dateString
        actionStackView.reloadInputViews()
        layoutIfNeeded()
    }
    
    
    func updateLikeButton() {
        guard let hasLiked = viewModel?.likedStatus else {return}
        self.setNeedsLayout()
        self.layoutIfNeeded()
        if hasLiked {
            self.actionBar.leftButtons[0].setImage(UIImage(named: "heart-red"), for: .normal)
            self.actionBar.leftButtons[0].tintColor = .red
        } else {
            self.actionBar.leftButtons[0].setImage(UIImage(named: "like1"), for: .normal)
            self.actionBar.leftButtons[0].tintColor = .label
        }
    }
    
    func didTapLikeButton() {
        guard let button = self.actionBar.leftButtons.first else {return}
        guard let hasLiked = viewModel?.likedStatus else {return}
        guard let viewModel = viewModel else {
            return
        }

        if hasLiked {
            viewModel.unlikeStatus()
        } else {
            viewModel.likeStatus()
        }
        
        let fakeNumberLikes = viewModel.numberLikesInt
        
        if fakeNumberLikes == 0 {
//            self.numberLikesButton.isHidden = true
//            self.delegate?.updateCell(indexPath: self.indexPath)
        } else {
//            self.numberLikesButton.isHidden = false
        }
        
        if fakeNumberLikes <= 1 {
            self.numberLikesButton.setTitle("\(fakeNumberLikes) like ", for: .normal)
        } else {
            self.numberLikesButton.setTitle("\(fakeNumberLikes) likes ", for: .normal)
        }

        let transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        UIView.animate(withDuration: 0.15) {
            button.transform = transform
            if  hasLiked {
                button.setImage(UIImage(named: "like1"), for: .normal)
                button.tintColor = .label

            } else {

                button.setImage(UIImage(named: "heart-red"), for: .normal)
                button.tintColor = .red
            }
        } completion: { _ in
            button.transform = .identity
        }
    }
    
    //MARK: - Selectors
    @objc func handelDoubleTapPhotoImageView() {
        didTapLikeButton()
        
        let transform = CGAffineTransform(scaleX: 120 / 25, y: 102 / 25)
        UIView.animate(withDuration: 0.3) {
            self.heardLikemageView.transform = transform
            self.heardLikemageView.isHidden = false
            
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.13) {
                self.heardLikemageView.transform = .identity
                self.heardLikemageView.isHidden = true
            }
        }
    }
    
    
    @objc func handleAvatarImageTapped() {
        guard let status = viewModel?.status else {return}
        self.delegate?.didSelectAvatar(status: status)
    }
    
    @objc func handelAllCommentButtonTapped() {
        guard let viewModel = viewModel else {
            return
        }

        self.delegate?.didSelectCommentButton(cell: self, status: viewModel.status)
    }
    
    @objc func handleNumberLikeButtonTapped() {
        guard let viewModel = viewModel else {
            return
        }

        self.delegate?.didSelectNumberLikesButton(status: viewModel.status)
    }
    
}
//MARK: - delegate
extension HomeFeedCollectionViewCell: CommentDelegate {
    func didPostComment(numberComments: Int) {
        if numberComments == 0 {
            self.allCommentsButton.setTitle("Add comments...", for: .normal)
        } else if numberComments == 1  {
            self.allCommentsButton.setTitle("See all \(numberComments) comment", for: .normal)
        } else {
            self.allCommentsButton.setTitle("See all \(numberComments) comments", for: .normal)
        }
    }
}
