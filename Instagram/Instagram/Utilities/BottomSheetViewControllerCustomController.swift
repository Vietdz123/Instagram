//
//  BottomSheetCustomView.swift
//  Instagram
//
//  Created by Long Bảo on 20/05/2023.
//


import UIKit

///For adding a ViewController as bottomSheetViewController

class BottomSheetViewControllerCustomController: UIViewController {
    //MARK: - Properties
    private var isPresentingSelectVC: Bool = true
    private var bottomSheetViewConstraint: NSLayoutConstraint!
    
    var bottomSheetViewController: UIViewController {
        fatalError("Subclasses must override 'bottomSheetViewController'")
    }
    
    private var bottomSheetView: UIView {
        return bottomSheetViewController.view
    }
    
    var canMoveBottomSheet: Bool {
        return true
    }
    
    var durationDismissing: (() -> Void)?
    
    var durationAnimation: CGFloat {
        return 0.2
    }
    
    var heightBottomSheetView: CGFloat {
        return 400
    }
    
    ///Xét space người dùng có thể scroll pass top
    var maxHeightScrollTop: CGFloat {
        return 100
    }
    
    ///Xét space to bottom
    var minHeightScrollBottom: CGFloat {
        return 60
    }
    
    var maxVeclocity: CGFloat {
        return 900
    }
    
    private let shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupShadowView()
        configureBottomSheet()
    }
    
    
    //MARK: - Helpers
    func configureBottomSheet() {
        addChild(bottomSheetViewController)
        view.addSubview(bottomSheetView)
        didMove(toParent: self)
        
        view.backgroundColor = .clear
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        if self.canMoveBottomSheet {
            bottomSheetView.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                                        action: #selector((handleBottomSheetViewMoved))))
            bottomSheetView.isUserInteractionEnabled = true
        }

        bottomSheetViewConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.bottomAnchor,
                                                                         constant: -self.heightBottomSheetView)
        NSLayoutConstraint.activate([
            bottomSheetViewConstraint,
            bottomSheetView.heightAnchor.constraint(equalTo: view.heightAnchor),
            bottomSheetView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bottomSheetView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        self.view.layoutIfNeeded()
    }
    
    func setupShadowView() {
        view.addSubview(shadowView)
        shadowView.backgroundColor = .clear
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shadowView.topAnchor.constraint(equalTo: view.topAnchor),
            shadowView.leftAnchor.constraint(equalTo: view.leftAnchor),
            shadowView.rightAnchor.constraint(equalTo: view.rightAnchor),
            shadowView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        self.shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                               action: #selector(animationDismiss)))
        self.shadowView.isUserInteractionEnabled = true
    }
    
    //MARK: - Selectors
    @objc func handleBottomSheetViewMoved(sender: UIPanGestureRecognizer) {
        let y = sender.translation(in: view).y
        let veclocitY = sender.velocity(in: view).y
        let heightView = self.view.frame.height

         if sender.state == .changed {
             if y > -self.maxHeightScrollTop {
                 UIView.animate(withDuration: self.durationAnimation) {
                    let transform = CGAffineTransform(translationX: 0, y: y)
                    self.bottomSheetView.transform = transform
                }
            }
        } else if sender.state == .ended {
            if veclocitY > self.maxVeclocity {
                self.animationDismiss()
                return
            }
            
            if (heightView - bottomSheetView.frame.minY) > self.minHeightScrollBottom {
                UIView.animate(withDuration: self.durationAnimation) {
                    self.bottomSheetView.transform = .identity
                }
            } else {
                self.animationDismiss()
            }
        }
    }
    
    @objc func animationDismiss() {
        if isPresentingSelectVC {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: self.durationAnimation) {
                self.bottomSheetViewConstraint.constant = 0
                self.view.layoutIfNeeded()
                self.durationDismissing?()
            } completion: { _ in
                self.dismiss(animated: true, completion: .none)
            }
            
        } else {
            UIView.animate(withDuration: self.durationAnimation) {
                self.bottomSheetViewConstraint.constant = -self.heightBottomSheetView
                self.view.layoutIfNeeded()
            }
        }
        
        self.isPresentingSelectVC = !isPresentingSelectVC
    }
}
//MARK: - delegate
