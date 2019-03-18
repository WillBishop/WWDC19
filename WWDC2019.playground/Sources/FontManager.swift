import Foundation
import AppKit
import SpriteKit

public class FontManager{
    
    //Instantiate an NSFont given the name we registered on launch. We know it will be successful as the file is included in our bundle, so we can safely force unwrap it
    static let neonFont = NSFont(name: "Halogen Gas Lights", size: 50)!
    
    
    /// Take an SKLabelNode and converts it to halogen font SKLabelNode.
    ///
    /// - Parameters:
    ///   - label: The label you wish to chance
    ///   - text: The text you wish to give the label
    ///   - fontSize: The size of the font in points
    ///   - color: The colour you wish to give the font
    public static func convertToHalogen(label: SKLabelNode?, text: String, fontSize: CGFloat, withColor color: NSColor){
        //Instantiate a new NSFont based on the neonFont declared above, we the only difference being font size
        let sizedNeonFont = NSFont(descriptor: FontManager.neonFont.fontDescriptor, size: fontSize)
        
        //Create an attributed string with size specified by the user and the font specified above.
        let halogenMessage = NSMutableAttributedString(string: text, attributes: [
            .font: sizedNeonFont,
            .foregroundColor: color
            ])
        
        //Assign it to the passed label.
        label?.attributedText = halogenMessage
    }
    
    public static func registerFont(withName fileName: String, andExtension fileExtension: String = "ttf"){
        let fontURL = Bundle.main.url(forResource: fileName, withExtension: fileExtension)
        CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
    }
}
