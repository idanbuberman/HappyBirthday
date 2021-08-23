//
//  ThemeRetriever.swift
//  HappyBirthday
//
//  Created by Idan Boberman on 23/08/2021.
//  Copyright © 2021 idan boberman. All rights reserved.
//

import Foundation
import UIKit

class ThemeRetriever {
    
    struct ScreenTheme {
        var backgroundColor: UIColor!
        var backgroundImage: UIImage!
        var pictureImage: UIImage!
        var uploadImage: UIImage!
        
        init(backgroundColor: UIColor!, background: String!, picture: String!, upload: String!) {
            self.backgroundColor = backgroundColor
            backgroundImage = UIImage(named: background)
            pictureImage = UIImage(named: picture)
            uploadImage = UIImage(named: upload)
        }
    }
    
    let backgroundImages: [ScreenTheme] = [ScreenTheme(backgroundColor: UIColor(red: 254/255, green: 239/255, blue: 203/255, alpha: 1.0),
                                                       background: "iOsBgElephant",
                                                       picture: "defaultPlaceHolderYellow",
                                                       upload: "cameraIconYellow"),
                                           ScreenTheme(backgroundColor: UIColor(red: 197/255, green: 232/255, blue: 223/255, alpha: 1.0),
                                                       background: "iOsBgFox",
                                                       picture: "defaultPlaceHolderGreen",
                                                       upload: "cameraIconGreen"),
                                           ScreenTheme(backgroundColor: UIColor(red: 218/255, green: 241/255, blue: 246/255, alpha: 1.0),
                                                       background: "iOsBgPelican2",
                                                       picture: "defaultPlaceHolderBlue",
                                                       upload: "cameraIconBlue")]
    
    func getRandomTheme() -> ScreenTheme {
        let randomIndex = Int(arc4random() % UInt32(backgroundImages.count))
        return backgroundImages[randomIndex]
    }
    
}
