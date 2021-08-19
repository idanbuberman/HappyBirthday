//
//  ViewController.swift
//  HappyBirthday
//
//  Created by Idan Boberman on 19/08/2021.
//  Copyright © 2021 idan boberman. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var birthday: UIDatePicker!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var birthdayScreenButton: UIButton!
    
    // MARK: - View controller lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.saveDataFromScreen),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.retrieveDataToScreen),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didEnterBackgroundNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didBecomeActiveNotification,
                                                  object: nil)
    }
    
    // MARK: - User input data 
    
    @objc func saveDataFromScreen() {
        let defaults = UserDefaults.standard
        
        defaults.set(nameTextField.text, forKey: "name")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        let birthdayString = dateFormatter.string(from: birthday.date)
        defaults.set(birthdayString, forKey: "birthday")
        
        do {
            var imageData: Data?
            if let image = picture.image {
                imageData = try NSKeyedArchiver.archivedData(withRootObject: image, requiringSecureCoding: false)
            }
            defaults.set(imageData, forKey: "picture")
        } catch {
            print("Couldn't save image")
        }
        
        defaults.synchronize()
    }
    
    @objc func retrieveDataToScreen() {
        let defaults = UserDefaults.standard
        
        if let savedText = defaults.string(forKey: "name") {
            nameTextField.text = savedText
            print("Textfield Text: \(savedText)")
        }
        
        if let birthdayString = defaults.string(forKey: "birthday") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/YYYY"
            let date = dateFormatter.date(from: birthdayString) ?? Date.distantPast
            
            birthday.setDate(date, animated: false)
            print("Textfield Text: \(birthdayString)")
        }
        
        do {
            if let pictureData = defaults.data(forKey: "picture") {
                let imageData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(pictureData) as! Data
                if let image = UIImage(data: imageData) {
                    picture.image = image
                }
            }
        } catch {
            print("Couldn't load image")
        }
    }
}

