//
//  BirthdayViewController.swift
//  HappyBirthday
//
//  Created by Idan Boberman on 19/08/2021.
//  Copyright © 2021 idan boberman. All rights reserved.
//

import UIKit

class BirthdayViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var name: String!
    var date: Any!
    var pic: UIImage?
    
    var imagePicker = UIImagePickerController()

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var bigBackgroundImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageImageView: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var uploadPictureButton: UIButton!
    @IBOutlet weak var uploadButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadButtonLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var shareTheNewsButton: UIButton!
    
    // MARK: - View controller lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNameLabel()
        setAgeImageAndLabel()
    }
    
    @IBOutlet weak var behindTheShareView: UIView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Random theme
        let randomTheme = ThemeRetriever().getRandomTheme()
        self.view.backgroundColor = randomTheme.backgroundColor
        bigBackgroundImageView.image = randomTheme.backgroundImage
        uploadPictureButton.setImage(randomTheme.uploadImage, for: .normal)
        pictureImageView.image = pic ?? randomTheme.pictureImage
        pictureImageView.layoutIfNeeded()
        
        // Chamford edges
        pictureImageView.layer.cornerRadius = pictureImageView.frame.size.width / 2
        shareTheNewsButton.layer.cornerRadius = shareTheNewsButton.frame.size.height / 2
        behindTheShareView.layer.cornerRadius = shareTheNewsButton.frame.size.height / 2

        // Placing upload photo button on photo circle on 45 degrees 📐
        let radius = Double(pictureImageView.frame.size.width) / 2
        let pos = calculateUploadButtonPosition(radius: radius, angle: 45)
        uploadButtonBottomConstraint.constant = CGFloat(pos.y) - (uploadPictureButton.frame.size.height / 2)
        uploadButtonLeadingConstraint.constant = CGFloat(pos.x) - (uploadPictureButton.frame.size.width / 2)
    }
    
    // MARK: - IBActions

    @IBAction func popViewController(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func uploadPicture(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else { return }
        
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareBirthday(_ sender: UIButton) {
        
        // Takes screenshot
        let screenshot = takeScreenshot(of: self.view)
        
        // set up activity view controller
        let items = [ screenshot ]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    
        activityViewController.popoverPresentationController?.sourceView = self.nameLabel
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.addToReadingList ]
        
        // present the view controller
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The end of the method - finally, dismiss picker
        defer { self.dismiss(animated: true) }
        
        // Setting image chosen by user
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        pictureImageView.image = image
        uploadedPhoto = image
        
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Class methods
    
    func takeScreenshot(of view: UIView) -> UIImage {
        
        // Hiding unneeded UIViews in screenshot
        hideViewsBeforeScreenshot()
        
        // Getting screenshot from graphics
        UIGraphicsBeginImageContextWithOptions(CGSize(width: view.bounds.width, height: view.bounds.height), false, 2)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Showing UIViews in screenshot back again
        showViewsAfterScreenshot()
        
        return screenshot
    }
    
    // MARK: UI Manipulation
    
    func calculateUploadButtonPosition(radius: Double, angle: Double) -> CGPoint {
        let x = cos(angle * Double.pi / 180) * radius
        let y = sin(angle * Double.pi / 180) * radius
        return CGPoint(x: x, y: y)
    }

    func hideViewsBeforeScreenshot() {
        backButton.isHidden = true
        uploadPictureButton.isHidden = true
        shareTheNewsButton.isHidden = true
    }
    
    func showViewsAfterScreenshot() {
        backButton.isHidden = false
        uploadPictureButton.isHidden = false
        shareTheNewsButton.isHidden = false
    }
    
    func setNameLabel() {
        nameLabel.text = "TODAY " + name + " IS"
    }
    
    func setAgeImageAndLabel() {
        guard let dateOfBirth = date as? Date else { return }
        
        let months = Calendar.current.dateComponents([Calendar.Component.month], from: dateOfBirth, to: Date()).month ?? 0
        let age = (months / 12 > 0) ? (months / 12) : (months % 12)

        ageImageView.image = UIImage(named: "\(age)")
        ageLabel.text = "\((months / 12 > 0) ? "YEAR" : "MONTH") OLD!"
    }
}
