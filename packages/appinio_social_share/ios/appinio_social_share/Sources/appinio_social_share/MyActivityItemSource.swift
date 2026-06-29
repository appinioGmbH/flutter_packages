//
//  MyActivityItemSource.swift
//  appinio_social_share
//
//  Created by Mujeeb khan on 23.09.22.
//

import Foundation
import LinkPresentation

@available(iOS 13,*)
class MyActivityItemSource: NSObject, UIActivityItemSource {
    var title: String
    var text: String
    var filePath: String
    
    init(title: String, text: String, filePath: String) {
        self.title = title
        self.text = text
        self.filePath = filePath
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return text
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return title
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata {
            let metadata = LPLinkMetadata()
            metadata.title = title
            metadata.iconProvider = NSItemProvider(object: UIImage(contentsOfFile: filePath)!)
            //This is a bit ugly, though I could not find other ways to show text content below title.
            //https://stackoverflow.com/questions/60563773/ios-13-share-sheet-changing-subtitle-item-description
            //You may need to escape some special characters like "/".
            metadata.originalURL = URL(fileURLWithPath: text)
            return metadata
    }
    
}
