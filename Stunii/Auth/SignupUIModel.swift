//
//  SignupUIModel.swift
//  Stunii
//
//  Created by Zap.Danish on 29/06/19.
//  Copyright © 2019 Gorilla App Development. All rights reserved.
//

import UIKit

struct SignUpUIModel {
    
    private(set) var titles             : [String] = []
    private(set) var optionsHeading     : String = ""
    private(set) var images             : [UIImage] = []
    private(set) var bgImage            : UIImage!
    private(set) var scratchImage       : UIImage!
    private(set) var progressImage      : UIImage!
    private(set) var keyboardType       : [UIKeyboardType]!
    
    func get() -> [SignUpUIModel] {
        return populateData()
    }
    
    private func populateData() -> [SignUpUIModel] {
        let array: [SignUpUIModel] = [
            SignUpUIModel(
                titles: ["First Name", "Last Name", "DOB"],
                optionsHeading: "",
                images: [],
                bgImage: #imageLiteral(resourceName: "screen1-bg"),
                scratchImage: #imageLiteral(resourceName: "cracking"),
                progressImage: #imageLiteral(resourceName: "progress1"),
                keyboardType: [.default, .default, .numberPad]
            ),
            SignUpUIModel(
                titles: ["Educational Email Address", "Personal Email Address", "Phone Number"],
                optionsHeading: "",
                images: [],
                bgImage: #imageLiteral(resourceName: "screen2-bg"),
                scratchImage: #imageLiteral(resourceName: "cracking"),
                progressImage: #imageLiteral(resourceName: "progress2"),
                keyboardType: [.emailAddress, .emailAddress, .phonePad]
            ),
            SignUpUIModel(
                titles: ["Educational Institute", "Course", "Graduation Date"],
                optionsHeading: "",
                images: [],
                bgImage: #imageLiteral(resourceName: "screen3-bg"),
                scratchImage: #imageLiteral(resourceName: "cracking"),
                progressImage: #imageLiteral(resourceName: "progress3"),
                keyboardType: [.default, .default, .numberPad]
            ),
            
            SignUpUIModel(titles: [],
                          optionsHeading: "",
                          images: [],
                          bgImage: #imageLiteral(resourceName: "bg-password"),
                          scratchImage: #imageLiteral(resourceName: "create-password"),
                          progressImage: #imageLiteral(resourceName: "progress4"),
                          keyboardType: []
                ),
                
            SignUpUIModel(
                titles: ["Male", "Female", "Other", ""],
                optionsHeading: "Gender",
                images: [#imageLiteral(resourceName: "male"), #imageLiteral(resourceName: "female"), #imageLiteral(resourceName: "other"), #imageLiteral(resourceName: "direction")],
                bgImage: #imageLiteral(resourceName: "screen4-bg"),
                scratchImage: #imageLiteral(resourceName: "nearly-there"),
                progressImage: #imageLiteral(resourceName: "progress5"),
                keyboardType: []

            ),
            SignUpUIModel(
                titles: ["Vegan", "Veggie", "Meat Eater", ""],
                optionsHeading: "Are You?",
                images: [#imageLiteral(resourceName: "vegan"), #imageLiteral(resourceName: "veggie"), #imageLiteral(resourceName: "meat-eater"), #imageLiteral(resourceName: "home_g")],
                bgImage: #imageLiteral(resourceName: "screen5-bg"),
                scratchImage: #imageLiteral(resourceName: "nearly-there"),
                progressImage: #imageLiteral(resourceName: "progress6"),
                keyboardType: []

            ),
            SignUpUIModel(
                titles: ["Nightlife", "Pub", "Meal", "Cozy"],
                optionsHeading: "Perfect Night Out",
                images: [#imageLiteral(resourceName: "nightclub"), #imageLiteral(resourceName: "pub"), #imageLiteral(resourceName: "meal"), #imageLiteral(resourceName: "cozy")],
                bgImage: #imageLiteral(resourceName: "screen6-bg"),
                scratchImage: #imageLiteral(resourceName: "nearly-there"),
                progressImage: #imageLiteral(resourceName: "progress7"),
                keyboardType: []

            ),
            SignUpUIModel(
                titles: ["At Gym", "At Library", "Gaming", "Outdoors"],
                optionsHeading: "You're most likely to find me:",
                images: [#imageLiteral(resourceName: "gym"), #imageLiteral(resourceName: "library"), #imageLiteral(resourceName: "gaming"), #imageLiteral(resourceName: "outdoors")],
                bgImage: #imageLiteral(resourceName: "screen7-bg"),
                scratchImage: #imageLiteral(resourceName: "last-step"),
                progressImage: #imageLiteral(resourceName: "progress8"),
                keyboardType: []

            )
        ]
        return array
    }
}
