//
//  ViewController.swift
//  DraggingButton
//
//  Created by Vinoth on 15/12/23.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var dragableButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bottomCcontainer: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var downArrowImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.layer.cornerRadius = 50
        bottomView.layer.borderColor = UIColor(displayP3Red: 37, green: 41, blue: 42, alpha: 0.1).cgColor
        bottomView.layer.borderWidth = 2.5
        bottomView.clipsToBounds = true
        statusLabel.isHidden = true
        activityIndicator.isHidden = true
        animateArrowImageAndCredButn()
    }
    
    func animateArrowImageAndCredButn() {
        downArrowImage.tintColor = UIColor.green
        let colors: [UIColor] = [UIColor.green, UIColor.black]
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat], animations: {
            colors.forEach({ self.downArrowImage.tintColor = $0 })
        }, completion: nil)

        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction] , animations: {
                self.dragableButton.frame = CGRect(x: self.dragableButton.center.x - 50, y: 380, width: self.dragableButton.frame.size.width, height: self.dragableButton.frame.size.height)
            }) { (completed) in
                self.dragableButton.frame = CGRect(x: -self.dragableButton.center.x - 60, y: -90, width: self.dragableButton.frame.size.width, height: self.dragableButton.frame.size.height)
            }
            self.dragableButton?.addTarget(self, action: #selector(self.wasDragged(buttn:event:)), for: .touchDragInside)
        }
    }
    
    @objc
    func wasDragged(buttn: UIButton, event: UIEvent) {
        let touch: UITouch = (event.touches(for: buttn)?.first)! as UITouch
        let previousLocation: CGPoint = touch .previousLocation(in: buttn)
        let location: CGPoint = touch .location(in: buttn)
        let deltaX: CGFloat = location.x - previousLocation.x
        let deltaY: CGFloat = location.y - previousLocation.y
        buttn.center = CGPoint(x: buttn.center.x + deltaX, y: buttn.center.y + deltaY)
        
        if buttn.frame.origin.y + (buttn.frame.size.height / 2) >= bottomCcontainer.frame.origin.y {
            dragableButton.isHidden = true
            activityIndicator.isHidden = false
            dragableButton.center = bottomView.center
            self.bottomView.isHidden = false

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: DispatchWorkItem(block: {
                self.updateUI(true)
            }))
        }
    }
    
    func updateUI(_ isSuccess: Bool) {
        debugPrint("button center ::::::::", isSuccess)
        if isSuccess {
            self.statusLabel.isHidden = false
            self.bottomView.isHidden = true
            self.downArrowImage.isHidden = true
            self.statusLabel.text = "Successfully Dropped"
        } else {
            //todo:// some operation
            self.showToast(message: "No internet connection!", seconds: 2)
            self.dragableButton.isHidden = false
            self.bottomView.isHidden = false
            self.activityIndicator.isHidden = true
            self.statusLabel.isHidden = false
            self.statusLabel.text = "failure"
            self.animateArrowImageAndCredButn()
        }
    }
}

extension UIViewController {
    func showToast(message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        alert.view.backgroundColor = .red
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}
