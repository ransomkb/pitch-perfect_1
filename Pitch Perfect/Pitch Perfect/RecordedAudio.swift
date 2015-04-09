//
//  RecordedAudio.swift
//  Pitch Perfect
//  Model to store recording-data
//
//  Created by Ransom Barber on 4/7/15.
//  Copyright (c) 2015 Hart Book. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathURL: NSURL!
    var title: String!
    var fileType: String?
    
    override init() {
        title = "movie_quote"
        fileType = "mp3"
        filePathURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(title, ofType: fileType)!)
    }
    
    init(fromFilePathURL filePathURL:NSURL, fromTitle title:String) {
        self.title = title
        self.filePathURL = filePathURL
    }
    
    init(fromTitle title:String, fromFileType fileType: String) {
        self.title = title
        self.fileType = fileType
        self.filePathURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(title, ofType: fileType)!)
    }
}
