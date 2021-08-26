//
//  SettingsModel.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-08-16.
//
import UIKit
import Foundation

struct SettingsSections{
    let title : String
    let options : [SettingOptions]
}

struct SettingOptions{
    let title : String
    let image : UIImage?
    let handler : (()->Void)
}
