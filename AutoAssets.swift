/*
 Usage:
 Add a Run Script to the Target’s Build Phases
 Set the Shell to "/usr/bin/swift"
 Paste this code into the script block
 This script generates a "AutoAssets.swift" file in the Source's directory
 
 Include "AutoAssets.swift" in your project
 
 You can then access your Assets by using the following style
 
 let myImage = Assets.MyCustomImage.image()
 */

import Cocoa

// Get the sources folder
guard let sourcePath = NSProcessInfo.processInfo().environment["SRCROOT"] else {
    exit(EXIT_FAILURE)
}

// Get the build SDK and set the image class to use based on it
guard let sdkName = NSProcessInfo.processInfo().environment["SDK_NAME"] else {
    exit(EXIT_FAILURE)
}
let imageClass: String
if sdkName.rangeOfString("osx") != nil {
    print("osx")
    imageClass = "NSImage"
}
else if sdkName.rangeOfString("ios") != nil {
    print("ios")
    imageClass = "UIImage"
}
else {
    exit(EXIT_FAILURE)
}

// Setup the source output with a comment at the top
var sourceString = "// DO NOT EDIT. This file is auto-generated and constantly overwritten.\n\n"

// We need Cocoa to support the UIImage / NSImage accessor
sourceString += "import Cocoa\n\n"

// Enumerate the files in 'resources' looking for .xcassets folders to parse
let fileManager = NSFileManager.defaultManager()
let files = fileManager.enumeratorAtPath(sourcePath)
while let file = files?.nextObject() as? String {
    
    if file.hasSuffix(".xcassets") {
        
        let assetName = file.lastPathComponent.stringByDeletingPathExtension
        let assetPath = sourcePath + "/" + file
        
        // start the enum
        sourceString += "enum \(assetName): String {\n"
        
        // add the cases for each imageset
        let imagesets = fileManager.enumeratorAtPath(assetPath)
        while let aImageset = imagesets?.nextObject() as? String {
            
            if aImageset.hasSuffix("imageset") {
                let caseName = aImageset.stringByDeletingPathExtension
                sourceString += "    case \(caseName)\n"
            }
        }
        
        // add the image accessor function
        sourceString += "\n    func image() -> \(imageClass) {\n        return \(imageClass)(named: self.rawValue)!\n    } \n"
        
        // end the enum
        sourceString += "}\n\n"
    }
}

let outputPath = sourcePath.stringByAppendingPathComponent("AutoAssets.swift")

print(sourceString)
print(outputPath)

do {
    try sourceString.writeToFile(outputPath, atomically: true, encoding: NSUTF8StringEncoding)
}
catch let error {
    exit(EXIT_FAILURE)
}
