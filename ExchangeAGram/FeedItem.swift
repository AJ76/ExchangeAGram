//
//  FeedItem.swift
//  ExchangeAGram
//
//  Created by Alan Platsky on 4/15/15.
//  Copyright (c) 2015 Alan Platsky. All rights reserved.
//

import Foundation
import CoreData

@objc (FeedItem)
class FeedItem: NSManagedObject {

    @NSManaged var caption: String
    @NSManaged var image: NSData

}
