import Foundation
import AppKit

public class ColorManager{
    
    //Define our neon colors for use throughout our app.
    public static let neonBlue = NSColor(red:0.46, green:0.98, blue:0.99, alpha:1.0)
    public static let neonGreen = NSColor(red:0.40, green:1.00, blue:0.70, alpha:1.0)
    public static let neonWhite = NSColor(red: 1, green: 1, blue: 1, alpha: 1)
    public static let neonRed = ColorManager.convertToColor("#E27DBC")
    
    public static func convertToColor(_ hex: String, alpha: CGFloat = 1.0) -> NSColor{
        //First we trim the hex to remove any whitespace or new lines
        var colorString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Check if it begins with a '#', as hex often does.
        if colorString.starts(with: "#"){
            colorString = String(colorString.dropFirst())
        }
        
        //Create a hex scanner from our colorString
        var hexConvertedValue: UInt32 = 0
        
        //Now we scan our colour string into a 24-bit UInt32, where each 8 bit corresponds to either red, green, or blue
        Scanner(string: colorString).scanHexInt32(&hexConvertedValue)
        
        //Now for each RGB, we pull out the correct value with 0x 00 00 00, with a 00 being replaced with FF if it's the value we want. ie. Blue is 0x0000FF
        
        //For red, we need to shift the bits 16 to the right, leaving just our 8-bit red colour code
        let red = CGFloat((hexConvertedValue & 0xFF0000) >> 16) / 255.0
        
        //For green, we need to shift the bits 8 to the right, which leaves a 16-bit colour code of both red and green, we then use 0x00FF00 to take the correct sequence
        let green = CGFloat((hexConvertedValue & 0x00FF00) >> 8) / 255.0
        
        //Blue doesn't require bit-shifting, we just need to specify which part we use with 0x0000FF
        let blue = CGFloat((hexConvertedValue & 0x0000FF)) / 255.0
        
        //All the values are than divided by 255 (as RGB goes up to 255, the highest number of a UInt8 value (256 - 1 for 0) to create a 0 to 1 value of red, green, and blue
        
        //Finally, we construct an NSColor from the values above
        return NSColor(red: red, green: green, blue: blue, alpha: alpha)
        
    }
}
