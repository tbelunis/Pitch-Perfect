//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by TOM BELUNIS on 3/16/15.
//  Copyright (c) 2015 TOM BELUNIS. All rights reserved.
//

import Foundation

// The model class for the PitchPerfect app.
// This class holds the URL and title for the 
// recorded audio.
class RecordedAudio: NSObject {
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl:NSURL, title:String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}