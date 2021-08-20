//
//  CGSize+AspectFunctions.swift
//  PhotoViewer
//
//  Created by Eric Zelermyer on 8/19/21.
//

// port of http://stackoverflow.com/a/17948778/3071224
import UIKit
import Foundation

extension CGSize {
    static func aspectFit(aspectRatio : CGSize, boundingSize: CGSize) -> CGSize {
        let mW = boundingSize.width / aspectRatio.width;
        let mH = boundingSize.height / aspectRatio.height;

        var aspectSize: CGSize = boundingSize
        if( mH < mW ) {
            aspectSize.width = boundingSize.height / aspectRatio.height * aspectRatio.width;
        }
        else if( mW < mH ) {
            aspectSize.height = boundingSize.width / aspectRatio.width * aspectRatio.height;
        }
        
        return aspectSize
    }
    
    static func aspectFill(aspectRatio :CGSize, minimumSize: CGSize) -> CGSize {
        let mW = minimumSize.width / aspectRatio.width;
        let mH = minimumSize.height / aspectRatio.height;

        var aspectSize: CGSize = minimumSize
        if( mH > mW ) {
            aspectSize.width = minimumSize.height / aspectRatio.height * aspectRatio.width;
        }
        else if( mW > mH ) {
            aspectSize.height = minimumSize.width / aspectRatio.width * aspectRatio.height;
        }
        
        return aspectSize
    }
}
