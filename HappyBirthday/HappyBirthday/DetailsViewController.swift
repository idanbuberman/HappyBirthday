//
//  ViewController.swift
//  HappyBirthday
//
//  Created by Idan Boberman on 19/08/2021.
//  Copyright © 2021 idan boberman. All rights reserved.
//

import UIKit

var uploadedPhoto: UIImage?

class DetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthday: UIDatePicker!
    @IBOutlet weak var birthdayScreenButton: UIButton!
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Adding observers in order to save-retrieve data between app cycles
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.saveDataFromScreen),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.retrieveDataToScreen),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    deinit {
        
        // Removing observers
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didEnterBackgroundNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didBecomeActiveNotification,
                                                  object: nil)
    }
    
    //MARK: - IBActions

    @IBAction func uploadPicture(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else { return }
        
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The end of the method - finally, dismiss picker
        defer { self.dismiss(animated: true) }
        
        // Setting image chosen by user
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        uploadedPhoto = image
    }
    
    // MARK: - User input data 
    
    @objc func saveDataFromScreen() {
        
        // Using UserDefaults to save name and birthday
        let defaults = UserDefaults.standard
        
        defaults.set(nameTextField.text, forKey: "name")
        
        let dateFormatter = ISO8601DateFormatter()
        let birthdayString = dateFormatter.string(from: birthday.date)
        defaults.set(birthdayString, forKey: "birthday")
        
        defaults.synchronize()
        
        // Photo saving will occur on DocDir
        save(Image: uploadedPhoto, named: "uploadedPhoto.jpg")
    }
    
    func save(Image image: UIImage?, named name: String) {
        
        // Get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // Destination file url to save image
        let imageURL = documentsDirectory.appendingPathComponent(name)
        
        // Get UIImage jpeg data representation
        if let data = image?.jpegData(compressionQuality:  1.0) {
            do {
                // Writes the image data to disk
                try data.write(to: imageURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    @objc func retrieveDataToScreen() {
        
        // Using UserDefaults to retrieve name and birthday
        let defaults = UserDefaults.standard
        
        if let savedText = defaults.string(forKey: "name") {
            nameTextField.text = savedText
            print("User Defaults name: \(savedText)")
        }
        
        if let birthdayString = defaults.string(forKey: "birthday") {
            let dateFormatter = ISO8601DateFormatter()
            let date = dateFormatter.date(from: birthdayString) ?? Date.distantPast
            
            birthday.setDate(date, animated: false)
            print("User Defaults Birthday: \(birthdayString)")
        }
        
        // Retrieving Photo from DocDir
        uploadedPhoto = getPhoto(named: "uploadedPhoto.jpg")
    }
    
    func getPhoto(named name: String) ->  UIImage? {
        
        // Get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // Destination file url to get image
        let imageURL = documentsDirectory.appendingPathComponent(name)
        
        // Return image from docDir
        return UIImage(contentsOfFile: imageURL.path)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let birthdayVC = segue.destination as? BirthdayViewController else { return }
        
        saveDataFromScreen()
        
        birthdayVC.name = nameTextField.text
        birthdayVC.date = birthday.date
        birthdayVC.pic = uploadedPhoto
    }
}

