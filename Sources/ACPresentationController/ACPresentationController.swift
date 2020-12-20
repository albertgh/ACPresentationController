//
//  ACCommonPresentation.swift
//
//  Created by Albert Chu on 2019/6/28.
//

import Foundation
import UIKit

public extension UIViewController {
    func acpc_showPresentation(_ vc: ACPresentationControllerProtocol,
                               animated: Bool,
                               completion: (() -> Void)? = nil) {
        let present = ACPresentationController(presentedViewController: vc,
                                               presenting: self)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = present
        self.present(vc, animated: animated, completion: completion)
    }
}

extension ACPresentationController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        return self
    }
}

public protocol ACPresentationControllerProtocol: UIViewController {
    var acpc_dismissClosure: (() -> Void)? { get set }
    var acpc_controllerHeight: CGFloat { get set }
    
    // Optional
    var acpc_viewCornerRadius: CGFloat { get }
    var acpc_tapDimmingToDismiss: Bool { get }
    var acpc_dimmingAlpha: CGFloat { get }
    var acpc_panToDismissPercent: CGFloat { get }
    var acpc_grabberColor: UIColor { get }
    var acpc_needFullTopGrabber: Bool { get }
}

public extension ACPresentationControllerProtocol {
    var acpc_viewCornerRadius: CGFloat {
        return 8.0
    }
    var acpc_tapDimmingToDismiss: Bool {
        return true
    }
    var acpc_dimmingAlpha: CGFloat {
        return 0.3
    }
    var acpc_panToDismissPercent: CGFloat {
        return 0.5
    }
    var acpc_grabberColor: UIColor {
        return .systemGray
    }
    var acpc_needFullTopGrabber: Bool {
        return false
    }
}

public class ACPresentationController: UIPresentationController {
    static var animationDuration: TimeInterval = 0.25
    
    private var vcDidDismissClosure: (() -> Void)?
    private var controllerHeight: CGFloat
    
    private var dimmingAlpha: CGFloat
    private var panToDismissPercent: CGFloat
    
    private var grabberColor: UIColor
    private var needFullTopGrabber: Bool
    
    lazy var dimmingView: UIView = {
        let view = UIView()
        if let frame = self.containerView?.bounds {
            view.frame = frame
        }
        view.backgroundColor = UIColor.black.withAlphaComponent(self.dimmingAlpha)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped))
        view.addGestureRecognizer(gesture)
        return view
    }()
    
    static var panIndicatorSize: CGSize = CGSize(width: 100.0, height: 44.0)
    lazy var panIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let pan = UIPanGestureRecognizer(target: self, action: #selector(dismissPanGesture(sender:)))
        view.addGestureRecognizer(pan)
        
        let grabberY: CGFloat = 5.0
        let grabberW: CGFloat = 36.0
        let grabberH: CGFloat = 5.0
        let grabber: UIView = UIView()
        grabber.backgroundColor = grabberColor
        grabber.layer.cornerRadius = grabberH / 2.0
        view.addSubview(grabber)
        grabber.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: grabber,
                                               attribute: .top,
                                               relatedBy: .equal,
                                               toItem: view,
                                               attribute: .top,
                                               multiplier: 1.0,
                                               constant: grabberY)
        topConstraint.isActive = true
        let xConstraint = NSLayoutConstraint(item: grabber,
                                             attribute: .centerX,
                                             relatedBy: .equal,
                                             toItem: view,
                                             attribute: .centerX,
                                             multiplier: 1.0,
                                             constant: 0.0)
        xConstraint.isActive = true
        let wConstraint = NSLayoutConstraint(item: grabber,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1.0,
                                             constant: grabberW)
        wConstraint.isActive = true
        let hConstraint = NSLayoutConstraint(item: grabber,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1.0,
                                             constant: grabberH)
        hConstraint.isActive = true
        return view
    }()
    
    private var originalY: CGFloat = 0.0
    
    public override init(presentedViewController: UIViewController,
                         presenting presentingViewController: UIViewController?) {
        if case let vc as ACPresentationControllerProtocol = presentedViewController {
            vcDidDismissClosure = vc.acpc_dismissClosure
            controllerHeight = vc.acpc_controllerHeight
            vc.view.layer.cornerRadius = vc.acpc_viewCornerRadius
            vc.view.clipsToBounds = true
            dimmingAlpha = vc.acpc_dimmingAlpha
            panToDismissPercent = vc.acpc_panToDismissPercent
            grabberColor = vc.acpc_grabberColor
            needFullTopGrabber = vc.acpc_needFullTopGrabber
        } else {
            vcDidDismissClosure = nil
            controllerHeight = UIScreen.main.bounds.width
            presentedViewController.view.layer.cornerRadius = 0.8
            presentedViewController.view.clipsToBounds = true
            dimmingAlpha = 0.3
            panToDismissPercent = 0.5
            grabberColor = .systemGray
            needFullTopGrabber = false
        }
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    public override func presentationTransitionWillBegin() {
        dimmingView.alpha = 0.0
        containerView?.addSubview(dimmingView)
        self.presentedViewController.view.addSubview(panIndicator)
        
        let transitionCoordinator = presentingViewController.transitionCoordinator!
        dimmingView.alpha = 0
        transitionCoordinator.animate(alongsideTransition: { (context) in
            self.dimmingView.alpha = 1.0
        }, completion: nil)
    }
    
    public override func dismissalTransitionWillBegin() {
        let transitionCoordinator = presentingViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { (context) in
            self.dimmingView.alpha = 0.0
        }, completion: nil)
    }
    
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
            panIndicator.removeFromSuperview()
        }
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        let containerViewBounds: CGRect = containerView?.bounds ?? UIScreen.main.bounds
        return CGRect(x: 0.0,
                      y: containerViewBounds.size.height - controllerHeight,
                      width: containerViewBounds.size.width,
                      height: controllerHeight)
    }
    
    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        dimmingView.frame = containerView?.bounds ?? UIScreen.main.bounds
        
        var panIndicatorSize = ACPresentationController.panIndicatorSize
        if needFullTopGrabber {
            panIndicatorSize.width = self.presentedViewController.view.bounds.size.width
        }
        let panIndicatorX: CGFloat = (dimmingView.frame.size.width - panIndicatorSize.width) / 2.0
        panIndicator.frame = CGRect(origin: CGPoint(x: panIndicatorX,
                                                    y: 0.0),
                                    size: panIndicatorSize)
    }
    
    public override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        
        if let container = container as? UIViewController,
           container == presentedViewController {
            containerView?.setNeedsLayout()
        }
    }
    
    public override func size(forChildContentContainer container: UIContentContainer,
                              withParentContainerSize parentSize: CGSize) -> CGSize {
        
        if let container = container as? UIViewController,
           container == presentedViewController {
            return container.preferredContentSize
        } else {
            return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        }
    }
}

extension ACPresentationController {
    @objc
    func dimmingViewTapped() {
        if case let vc as ACPresentationControllerProtocol = self.presentedViewController {
            guard vc.acpc_tapDimmingToDismiss else {
                return
            }
            self.presentingViewController.dismiss(animated: true) {
                if let didDismiss = vc.acpc_dismissClosure {
                    didDismiss()
                }
            }
        }
    }
    
    @objc
    dynamic func dismissPanGesture(sender: UIPanGestureRecognizer) {
        let translate = sender.translation(in: self.presentedView)
        switch sender.state {
        case .began:
            originalY = presentedViewController.view.frame.origin.y
        case .changed:
            if translate.y > 0 {
                presentedViewController.view.frame.origin.y = originalY + translate.y
            }
        case .ended:
            let presentedViewH = presentedViewController.view.frame.height
            let newY = presentedViewController.view.frame.origin.y
            
            let velocity = sender.velocity(in: sender.view?.superview)
            let speedY = velocity.y
            
            if speedY > 800.0 {
                // if speed is very fast, dismiss directly
                let duration: TimeInterval = TimeInterval((presentedViewH - (newY - originalY)) / speedY)
                dismissPresentation(duration: duration)
            } else if speedY < -600.0 {
                let duration: TimeInterval = TimeInterval((newY - originalY) / -speedY)
                restorePosition(duration: duration)
            } else if ((presentedViewH * panToDismissPercent) - (newY - originalY)) < 0.0 {
                dismissPresentation()
            } else {
                let duration: TimeInterval = TimeInterval((newY - originalY) / presentedViewH)
                restorePosition(duration: duration)
            }
        default:
            break
        }
    }
    
    private func restorePosition(duration: TimeInterval = ACPresentationController.animationDuration) {
        var animationOption: UIView.AnimationOptions = .curveEaseInOut
        if duration < ACPresentationController.animationDuration {
            animationOption = .curveLinear
        }
        var animationDuration: TimeInterval = duration
        if duration < 0.1 {
            animationDuration = 0.1
        }
        presentedViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: animationOption,
                       animations: {            self.presentedViewController.view.frame.origin.y = self.originalY
                        self.presentedViewController.view.layoutIfNeeded()
                       }, completion: nil)
    }
    
    private func dismissPresentation(duration: TimeInterval = ACPresentationController.animationDuration) {
        var animationOption: UIView.AnimationOptions = .curveEaseInOut
        if duration < ACPresentationController.animationDuration {
            animationOption = .curveLinear
        }
        var animationDuration: TimeInterval = duration
        if duration < 0.1 {
            animationDuration = 0.1
        }
        presentedViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: animationOption,
                       animations: {
                        self.presentedViewController.view.frame.origin.y = self.presentingViewController.view.frame.height
                        self.presentedViewController.view.layoutIfNeeded()
                       }, completion: { _ in
                        if case let vc as ACPresentationControllerProtocol = self.presentedViewController {
                            self.presentingViewController.dismiss(animated: true) {
                                if let didDismiss = vc.acpc_dismissClosure {
                                    didDismiss()
                                }
                            }
                        }
                       })
    }
}
