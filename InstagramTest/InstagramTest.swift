//
//  InstagramTest.swift
//  InstagramTest
//
//  Created by Seun Olalekan on 2021-08-24.
//

@testable import Instagram

import XCTest

class InstagramTest: XCTestCase {

    func testNotificationIDcreation(){
        
        let first = NotificationsManager.setIdentifier()
        let second = NotificationsManager.setIdentifier()
        XCTAssertNotEqual(first, second)
        
    }
   

}
