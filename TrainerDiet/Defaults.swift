//
//  Defaults.swift
//  TrainerDiet
//
//  Created by praveenm on 7/22/20.
//  Copyright © 2020 RadhaKrishna. All rights reserved.
//

import Foundation

class Defaults {

    public static var trainerFirstName: String? {

        get {
            return UserDefaults.standard.string(forKey: "trainerFirstName")
        }

        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "trainerFirstName")
            UserDefaults.standard.synchronize()
        }
    }

    public static var trainerLastName: String? {

        get {
            return UserDefaults.standard.string(forKey: "trainerLastName")
        }

        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "trainerLastName")
            UserDefaults.standard.synchronize()
        }
    }

    public static var trainer_GYM_ID: Int? {

        get {
            return UserDefaults.standard.integer(forKey: "trainer_GYM_ID")
        }

        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "trainer_GYM_ID")
            UserDefaults.standard.synchronize()
        }
    }
}
