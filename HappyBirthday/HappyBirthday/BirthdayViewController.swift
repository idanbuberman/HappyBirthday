//
//  BirthdayViewController.swift
//  HappyBirthday
//
//  Created by Idan Boberman on 19/08/2021.
//  Copyright © 2021 idan boberman. All rights reserved.
//

import UIKit
//import Darwin
class BirthdayViewController: UIViewController {
    
    @IBOutlet weak var shareTheNewsButton: UIButton!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var uploadPictureImageView: UIImageView!
    
    @IBOutlet weak var age: UIImageView!
//    @IBOutlet weak var uploadOriginX: NSLayoutConstraint!
//    @IBOutlet weak var uploadOriginY: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        shareTheNewsButton.layer.cornerRadius = shareTheNewsButton.frame.size.height / 2
//
//        let radius: CGFloat = uploadPictureImageView.frame.size.width / 2
//        let pos = calcButtonPosition(radius: Float(radius), angle: 45)
//        uploadOriginX.constant = pos.x
//        uploadOriginY.constant = pos.y
//    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let radius: CGFloat = uploadPictureImageView.frame.size.width / 2
//        let pos = calcButtonPosition(radius: Float(radius), angle: 45)
//
//    }

    func calcButtonPosition(radius: Float, angle: Float) -> CGPoint {
        let x: CGFloat = CGFloat(radius * cos(angle))
        let y: CGFloat = CGFloat(radius * sin(angle))
        return CGPoint(x: x, y: y)
    }
}
