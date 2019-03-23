import Foundation
import SpriteKit
import AVFoundation

public class LevelTwoScene: SKScene{
    
    let keys = ["A", "S", "D", "F", "G", "H"]
    var pianoKeyNodes = [SKSpriteNode]()
    var mappedPianoKeys = [String: SKSpriteNode]()
    let order = "AAGGHHGFFDDSSA"
    var playedKeys = ""
    var player: AVAudioPlayer?
    
    private var backButton: SKLabelNode?
    private var questionLabel: SKLabelNode?
    private var orderLabel: SKLabelNode?
    private var pianoInstruction: SKLabelNode?
    

    
    public override func didMove(to view: SKView) {
        backButton = self.childNode(withName: "backButton") as? SKLabelNode
        questionLabel = self.childNode(withName: "questionLabel") as? SKLabelNode
        orderLabel = self.childNode(withName: "orderLabel") as? SKLabelNode
        
        self.pianoKeyNodes = self.children.compactMap {$0 as? SKSpriteNode}
        
        for (index, element) in self.pianoKeyNodes.enumerated(){
            self.mappedPianoKeys[keys[index]] = element
        }
        
        pianoInstruction = self.childNode(withName: "pianoInstruction") as? SKLabelNode
        
        
        
        FontManager.convertToHalogen(
            label: backButton,
            text: "< Back",
            fontSize: 65.0,
            withColor: ColorManager.neonWhite
        )
        FontManager.convertToHalogen(label: questionLabel, text: "Play 'Twinkle Twinkle' on piano", fontSize: 50, withColor: ColorManager.neonBlue)
        FontManager.convertToHalogen(
            label: orderLabel,
            text: order,
            fontSize: 65.0,
            withColor: ColorManager.neonWhite
        )
        FontManager.convertToHalogen(
            label: pianoInstruction,
            text: "Play with your physical keyboard!",
            fontSize: 50,
            withColor: ColorManager.neonWhite
        )
    }
    public override func keyDown(with event: NSEvent) {
        self.handleKeyDownEvent(event)
    }
    public override func keyUp(with event: NSEvent) {
        self.handleKeyUp(event)
    }
    
    
    func handleKeyDownEvent(_ event: NSEvent){
        if let pressedCharacters = event.characters{
            pressedCharacters.forEach {char in
                playedKeys += (String(char).uppercased())
                
                switch char{
                case "a", "A":
                    print("Play Key A")
                    self.playKey("a")
                    self.animateKeyPress(forKey: "A", down: true)
                case "s", "S":
                    print("Play Key S")
                    self.playKey("s")
                    self.animateKeyPress(forKey: "S", down: true)
                case "d", "D":
                    print("Play Key D")
                    self.playKey("d")
                    self.animateKeyPress(forKey: "D", down: true)
                case "f", "F":
                    print("Play Key F")
                    self.playKey("f")
                    self.animateKeyPress(forKey: "F", down: true)
                case "g", "G":
                    print("Play Key G")
                    self.playKey("g")
                    self.animateKeyPress(forKey: "G", down: true)
                case "h", "H":
                    print("Play Key H")
                    self.playKey("h")
                    self.animateKeyPress(forKey: "H", down: true)
                default:
                    print("No sound for key")
                }
                if playedKeys.contains(order){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.userDidFinishLevel(2)
                    })
                }
            }
        }
    }
    func animateKeyPress(forKey key: String, down: Bool){
        self.mappedPianoKeys[key]?.color = down ? .gray : .white
       
    }
    func handleKeyUp(_ event: NSEvent){
        if let pressedCharacters = event.characters{
            pressedCharacters.forEach {char in
                switch char{
                case "a", "A":
                    print("Play Key A")
                    self.animateKeyPress(forKey: "A", down: false)
                case "s", "S":
                    print("Play Key S")
                    self.animateKeyPress(forKey: "S", down: false)
                case "d", "D":
                    print("Play Key D")
                    self.animateKeyPress(forKey: "D", down: false)
                case "f", "F":
                    print("Play Key F")
                    self.animateKeyPress(forKey: "F", down: false)
                case "g", "G":
                    print("Play Key G")
                    self.animateKeyPress(forKey: "G", down: false)
                case "h", "H":
                    print("Play Key H")
                    self.animateKeyPress(forKey: "H", down: false)
                default:
                    print("No sound for key")
                }
            }
        }
    }

    
    func playKey(_ key: String){
        guard let soundFile = Bundle.main.url(forResource: key, withExtension: "wav") else {return}
        NSSound(contentsOf: soundFile, byReference: false)?.play()
        
    }
    
    public override func mouseDown(with event: NSEvent) {
        let point = event.location(in: self)
        let hitNodes = self.nodes(at: point)
        //If the user clicks the back button, quit
        if hitNodes.contains(where: {$0.name == "backButton"}){
            quit()
        }
        
    }
    public var userDidFinishLevel: (Int) -> Void = {level in}
    
    //Define a closure to quit, which is overwritten when the class is instantiated.
    public var quit: () -> Void = {}
}
