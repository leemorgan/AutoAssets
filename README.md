AutoAssets
=====
AutoAssets is a Xcode build script (written in Swift) that generates a Swift source file based on the project's assets at build time.

AutoAssets generates a source file containing enumerations of each Xcode Asset, properly name spaced in the following style:
    
    enum IconAssets: String {
        case Music
		case Movies
        case TVShows
        
	    func image() -> NSImage {
            return NSImage(named: self.rawValue)!
        } 
    }




Instead of accessing image assets like this:

    UIImage(named:"someImage")

With the enums AutoAssets generates you can access them using proper name spacing:

    IconAssets.Music.image()

<br>

For more info see my post [here](http://blog.shiftybit.net/2015/07/autoassets-build-script/)

By [Lee Morgan](http://shiftybit.net). If you find this useful please let me know. I'm [@leemorgan](https://twitter.com/leemorgan) on twitter.


Usage
=====

1. Add a Run Script to the Target’s Build Phases

2. Set the Shell to `/usr/bin/swift`

3. Paste the AutoAssets.swift contents into the script block

AutoAssets generates a "AutoAssets.swift" file in the Source's directory at compile time.

Include the auto generated "AutoAssets.swift" in your project.

You can then access your Assets by using the following style:

    let myImage = Assets.MyCustomImage.image()


License
=======
The license is contained in the "License.txt" file.
