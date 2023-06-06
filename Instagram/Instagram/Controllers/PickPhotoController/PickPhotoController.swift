//
//  UploadFeedController.swift
//  Instagram
//
//  Created by Long Bảo on 15/05/2023.
//

import Foundation
import UIKit
import Photos

enum UsingPickPhotoType {
    case uploadTus
    case changeAvatar
}

protocol PickPhotoDelegate: AnyObject {
    func didSelectNextButton(image: UIImage?)
}

class PickPhotoController: UIViewController {
    //MARK: - Properties
    var fetchResult = PHFetchResult<PHAsset>()
    var photoImages: [UIImage?] = []
    var collectionView: UICollectionView!
    var headerPhotoView = PickPhotoHeaderView(frame: .zero)
    var numberItem = 0
    var shouldInsertCell = true
    let requestImageQueue = DispatchQueue(label: "Request Image Queue", attributes: .concurrent)
    var widthCropViewConstraint: NSLayoutConstraint!
    var latestYCropView: CGFloat = 0
    var expectePhotodRatio: Float = 0.75
    weak var delegate: PickPhotoDelegate?
    var type: UsingPickPhotoType
    
    private var heightImageHeader: CGFloat {
        return self.headerPhotoView.photoImageView.frame.height
    }
    
    private lazy var cropView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemCyan
        view.alpha = 0.3
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                         action: #selector(hanldeCropViewMoved)))
        return view
    }()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - View Lifecycle
    init(type: UsingPickPhotoType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        shouldInsertCell = true
        configureUI()
        configureProperties()
        requestAuthorization()
        headerPhotoView.photoImageView.image = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
        requestImageQueue.async {
            self.shouldInsertCell = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.numberItem = 0
        self.photoImages = []
        self.collectionView.reloadData()
    }
    

    
    
    //MARK: - Helpers
    func configureUI() {
        self.navigationController?.navigationBar.isHidden = true
        let appearTabBar = UITabBarAppearance()
        appearTabBar.backgroundColor = .white
        tabBarController?.tabBar.standardAppearance = appearTabBar
        tabBarController?.tabBar.scrollEdgeAppearance = appearTabBar
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayoutCollectionView())
        view.addSubview(headerPhotoView)
        view.addSubview(cropView)
        view.addSubview(collectionView)
        
        headerPhotoView.translatesAutoresizingMaskIntoConstraints = false
        self.widthCropViewConstraint = cropView.widthAnchor.constraint(equalToConstant: 0.05)
        NSLayoutConstraint.activate([
            headerPhotoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerPhotoView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerPhotoView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerPhotoView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 5 / 8),
            
            self.widthCropViewConstraint,
            cropView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cropView.heightAnchor.constraint(equalTo: cropView.widthAnchor,
                                                multiplier: 1 / CGFloat(expectePhotodRatio)),
            cropView.centerYAnchor.constraint(equalTo: headerPhotoView.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: headerPhotoView.bottomAnchor, constant: 0),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        
    }
    
    func configureProperties() {
        headerPhotoView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PickPhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PickPhotoCollectionViewCell.identifier)
    }
    
    func createLayoutCollectionView() -> UICollectionViewLayout {
        let itemSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalHeight(1.0))
        let item = ComposionalLayout.createItem(layoutSize: itemSize)
    
        let groupSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalWidth(0.2))
        let group = ComposionalLayout.createGroup(axis: .horizontal,
                                                  layoutSize: groupSize,
                                                  item: item,
                                                  count: 5)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(2)
        
        let section = ComposionalLayout.createSectionWithouHeader(group: group)
        section.interGroupSpacing = 2
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func requestAuthorization() {
        if PHPhotoLibrary.authorizationStatus(for: .readWrite) == .authorized {
            self.loadImage()
            return
        }
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .authorized:
                self.loadImage()
            case .denied:
                return
            default:
                return
            }
        }
        
    }
    
    func loadImage() {
        let manager = PHImageManager.default()
        self.fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOption())
        
        requestImageQueue.async {
            for i in 0..<self.fetchResult.count {
                let asset = self.fetchResult.object(at: i)
                let ratio: Float = Float(asset.pixelWidth) / Float(asset.pixelHeight)
                manager.requestImage(for: asset,
                                    targetSize: CGSize(width: Int(200 * ratio), height: 200),
                                    contentMode: .aspectFill,
                                    options: self.requestOption()) { imagePhoto, error in
                    if self.shouldInsertCell {
                        self.photoImages.append(imagePhoto)
                        DispatchQueue.main.async {
                            self.insertCell()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.numberItem = 0
                            self.photoImages = []
                            self.collectionView.reloadData()
                        }
                    }
                }
                
                if !self.shouldInsertCell {
                    break
                }
            }
        }
    }
    
    func fetchOption() -> PHFetchOptions {
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return option
    }
    
    func requestOption() -> PHImageRequestOptions {
        let request = PHImageRequestOptions()
        request.isSynchronous = true
        request.deliveryMode = .highQualityFormat
        return request
    }
    
    func insertCell() {
        if shouldInsertCell {
            self.numberItem = collectionView.numberOfItems(inSection: 0)
            let indexPath = IndexPath(item: self.numberItem, section: 0)
            numberItem += 1
            collectionView.insertItems(at: [indexPath])
        }
    }
    
    
    @objc func hanldeCropViewMoved(sender: UIPanGestureRecognizer) {
        view.layoutIfNeeded()
        let transition = sender.translation(in: view)
        
        if sender.state == .began {
            self.latestYCropView = cropView.frame.origin.y
        } else if sender.state == .changed {
            if cropView.frame.minY >= headerPhotoView.heightHeaderTitle + self.insetTop
                && cropView.frame.maxY <= (self.heightImageHeader + headerPhotoView.heightHeaderTitle + self.insetTop) {
                if transition.y + latestYCropView < headerPhotoView.heightHeaderTitle + self.insetTop {
                    cropView.frame = CGRect(x: cropView.frame.origin.x,
                                            y: headerPhotoView.heightHeaderTitle + self.insetTop,
                                            width: cropView.frame.width,
                                            height: cropView.frame.height)
                    return
                    
                } else if transition.y + latestYCropView + cropView.frame.height > (self.heightImageHeader + headerPhotoView.heightHeaderTitle + self.insetTop) {
                    cropView.frame = CGRect(x: cropView.frame.origin.x,
                                            y: self.heightImageHeader + headerPhotoView.heightHeaderTitle - cropView.frame.height + self.insetTop,
                                            width: cropView.frame.width,
                                            height: cropView.frame.height)
                    return
                }
                
                cropView.frame = CGRect(x: cropView.frame.origin.x,
                                        y: latestYCropView + transition.y,
                                        width: cropView.frame.width,
                                        height: cropView.frame.height)
            }
        }
    }
    //MARK: - Selectors
    
}
//MARK: - delegate
extension PickPhotoController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberItem
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PickPhotoCollectionViewCell.identifier, for: indexPath) as! PickPhotoCollectionViewCell
        cell.photoImageView.image = self.photoImages[indexPath.row]
        if indexPath.row == 1 {
            let manager = PHImageManager.default()
            let asset = self.fetchResult.object(at: 0)
            let ratio: Float = Float(asset.pixelWidth) / Float(asset.pixelHeight)
            
            if ratio < self.expectePhotodRatio {
                self.widthCropViewConstraint.constant = self.heightImageHeader * CGFloat(ratio)
                view.layoutIfNeeded()
            } else {
                self.widthCropViewConstraint.constant = 0.005
                view.layoutIfNeeded()
            }

            if type == .uploadTus {
                manager.requestImage(for: asset,
                                    targetSize: CGSize(width: Int(800 * ratio), height: 800),
                                    contentMode: .aspectFit,
                                    options: self.requestOption()) { image, _ in
                    self.headerPhotoView.photoImageView.image = image
                }
            } else {
                manager.requestImage(for: asset,
                                    targetSize: CGSize(width: Int(200 * ratio), height: 200),
                                    contentMode: .aspectFit,
                                    options: self.requestOption()) { image, _ in
                    self.headerPhotoView.photoImageView.image = image
                }
            }
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let manager = PHImageManager.default()
        
        let asset = self.fetchResult.object(at: indexPath.row)
        let ratio: Float = Float(asset.pixelWidth) / Float(asset.pixelHeight)
        
        if ratio < self.expectePhotodRatio {
            self.widthCropViewConstraint.constant = self.heightImageHeader * CGFloat(ratio)
            view.layoutIfNeeded()
        } else {
            self.widthCropViewConstraint.constant = 0.005
            view.layoutIfNeeded()
        }
        
        if type == .uploadTus {
            manager.requestImage(for: asset,
                                targetSize: CGSize(width: Int(800 * ratio), height: 800),
                                contentMode: .aspectFit,
                                options: self.requestOption()) { image, _ in
                self.headerPhotoView.photoImageView.image = image
            }
        } else {
            manager.requestImage(for: asset,
                                targetSize: CGSize(width: Int(250 * ratio), height: 250),
                                contentMode: .aspectFit,
                                options: self.requestOption()) { image, _ in
                self.headerPhotoView.photoImageView.image = image
            }
        }
    }
    
    func cropImage(image: UIImage?) -> UIImage? {
        guard let image = image else {
            return nil
        }
        
        view.layoutIfNeeded()
        let sourceCgImage = image.cgImage
        let heightImage = image.size.height
        let widthImage = image.size.width

        let yBeginCrop = heightImage * ((self.cropView.frame.minY -  self.headerPhotoView.photoImageView.frame.minY - self.insetTop) / self.heightImageHeader)

        let heightExpected = heightImage * CGFloat(self.expectePhotodRatio)
        
        let cropRect = CGRect(x: 0,
                              y: yBeginCrop,
                              width: widthImage,
                              height: heightExpected).integral

        guard let cropedCgImage = sourceCgImage?.cropping(to: cropRect) else {
            return nil
            
        }
        let imageExpected = UIImage(cgImage: cropedCgImage)
        return imageExpected
    }
}

extension PickPhotoController: PickHeaderPhotoDelegate {
    func didSelectbackButtonTapped() {
        if self.type == .changeAvatar {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?.first
    }
    
    func didSelectNexButton() {
        if self.type == .changeAvatar {
            self.delegate?.didSelectNextButton(image: self.headerPhotoView.photoImageView.image)
            navigationController?.popViewController(animated: true)
            return
        }
        
        guard let image = self.headerPhotoView.photoImageView.image else {return}
        
        let ratio = image.size.width / image.size.height
        
        if ratio < CGFloat(self.expectePhotodRatio) {
            self.headerPhotoView.photoImageView.image = self.cropImage(image: image)
        }
        
        let uploadFeedVC = UploadFeedController(imageUpload: headerPhotoView.photoImageView.image)
        self.navigationController?.pushViewController(uploadFeedVC, animated: false)
    }
    
    func didSelectCamera() {
        let camVC = CameraController(type: self.type)
        camVC.delegate = self
        navigationController?.pushViewController(camVC, animated: false)
    }
}

extension PickPhotoController: CameraDelegate {
    func didCapturePhoto(image: UIImage?) {
        self.delegate?.didSelectNextButton(image: image)
    }
    
    
}
