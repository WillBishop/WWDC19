import Foundation
import SpriteKit

public class LevelFourScene: SKScene{
    
    
    private var backButton: SKLabelNode?
    private var questionLabel: SKLabelNode?
    private var sentenceLabel: SKLabelNode?
    private var counterLabel: SKLabelNode?
    
    //Create an arrray of sentences
    fileprivate var sentences = [Sentence]()
    
    //Track the current sentence.
    fileprivate var currentSentence: Sentence?
    
    var potentialAnswers = [SKLabelNode]()
    var selectedNode: SKNode?
    var enterBox: SKNode?
    
    //When we set our completed questions, we update the counterLabel
    var completedQuestions = 0{
        didSet{
            FontManager.convertToHalogen(label: counterLabel, text: "\(completedQuestions)/3", fontSize: 50, withColor: ColorManager.neonGreen)
        }
    }
    
    public override func didMove(to view: SKView) {
        backButton = self.childNode(withName: "backButton") as? SKLabelNode
        questionLabel = self.childNode(withName: "questionLabel") as? SKLabelNode
        sentenceLabel = self.childNode(withName: "sentenceLabel") as? SKLabelNode
        counterLabel = self.childNode(withName: "counterLabel") as? SKLabelNode
        
        FontManager.convertToHalogen(label: counterLabel, text: "\(completedQuestions)/3", fontSize: 50, withColor: ColorManager.neonGreen)
        
        //Each `Sentence` object contains 6 variables
        sentences.append(Sentence(
            word: "there", //The correctly spelled there
            sentence: "The ball is over there!", //The complete sentence
            missing: "_____", //The word with a letter replaced with a '_'
            correctLetter: "THERE", //The correct letter (in capitals)
            enterPosition: CGPoint(x: 350, y: 141), //The onscreen position of the missing character.
            potentialLetters: ["they're", "their", "there"] //All the potential answers, of which only one is correct.
        ))
        sentences.append(Sentence(
            word: "saw",
            sentence: "I saw my friend yesterday.",
            missing: "___",
            correctLetter: "saw",
            enterPosition: CGPoint(x: -390, y: 141),
            potentialLetters: ["saw", "see"]
        ))
        sentences.append(Sentence(
            word: "run",
            sentence: "I went for a run",
            missing: "___",
            correctLetter: "run",
            enterPosition: CGPoint(x: 260, y: 141),
            potentialLetters: ["ran", "run", "will run"]
        ))
        
        if let sentence = self.sentences.randomElement(){
            self.setupQuestion(sentence)
        }
        
        
        FontManager.convertToHalogen(
            label: backButton,
            text: "< Back",
            fontSize: 65.0,
            withColor: ColorManager.neonWhite
        )
        FontManager.convertToHalogen(
            label: questionLabel,
            text: "Can you complete the sentences?",
            fontSize: 50,
            withColor: ColorManager.neonBlue
        )
        
        
    }
    
    //If the number intersects with one of our important elements, we return true, indicating to the caller to choose a new position.
    func numberIntersectsWithImportantObjects(_ answerLabel: SKLabelNode) -> Bool{
        return self.potentialAnswers.contains(where: {$0.frame.intersects(answerLabel.frame)}) ||
            (self.enterBox?.frame.intersects(answerLabel.frame) ?? false) ||
            (self.questionLabel?.frame.contains(answerLabel.frame) ?? false) || !self.frame.contains(answerLabel.frame)
    }
    
    fileprivate func setupQuestion(_ question: Sentence){
        //Remove existing objects
        self.enterBox?.removeFromParent()
        self.potentialAnswers.forEach {
            $0.removeFromParent()
        }
        self.potentialAnswers.removeAll()
        
        self.currentSentence = question
        //Construct our sentence label, replacing the correct word with the word with a letter removed.
        FontManager.convertToHalogen(label: sentenceLabel, text: question.sentence.replacingOccurrences(of: question.word, with: question.missing), fontSize: 65, withColor: ColorManager.neonGreen)
        
        //Consutrct our enterbox, slightly taller and wider than needed for easier use.
        let enterBox = SKShapeNode(rectOf: CGSize(width: 57 * question.correctLetter.count, height: 100))
        enterBox.position = question.enterPosition
        enterBox.fillColor = .clear
        enterBox.strokeColor = .clear
        enterBox.name = "enterBox"
        self.enterBox = enterBox
        self.addChild(enterBox)
        
        //For every potential letter
        question.potentialLetters.forEach {letter in
            //We construct a label
            let answerLabel = SKLabelNode()
            //Convert it to halogen.
            FontManager.convertToHalogen(label: answerLabel, text: String(letter), fontSize: 65, withColor: ColorManager.neonWhite)
            //Define our min and max positions.
            let maxY = 50
            let minY = -400
            let minX = -490
            let maxX = 460
            let positionY = CGFloat(Int.random(in: minY ... maxY))
            answerLabel.position.y = positionY
            answerLabel.position.x = CGFloat(Int.random(in: minX ... maxX))
            
            //While it intersects with an important object, we randomly choose a new location.
            while numberIntersectsWithImportantObjects(answerLabel){
                let positionY = CGFloat(Int.random(in: minY ... maxY))
                answerLabel.position.y = positionY
                answerLabel.position.x = CGFloat(Int.random(in: minX ... maxX))
            }
            potentialAnswers.append(answerLabel)
            
        }
        
        //For each answer we added it to the scene
        for (index, element) in potentialAnswers.enumerated(){
            if index != 0{
            }
            self.addChild(element)
        }
    }
    
    
    func executeAfter(_ seconds: Double, code: @escaping () -> Void){
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: {
            code()
        })
    }
    
    //When the user lets go of a node, we set it to nil.
    public override func mouseUp(with event: NSEvent) {
        self.selectedNode = nil
    }
    public override func mouseDragged(with event: NSEvent) {
        let position = event.location(in: self)
        let nodes = self.nodes(at: position)
        
        if let hitNode = self.selectedNode ?? nodes.first{
            //If we clicked on an important node, don't continue.
            if !( ((hitNode.name?.contains("enter")) ?? false) || ((hitNode.name?.contains("back")) ?? false) || ((hitNode.name?.contains("question")) ?? false) || ((hitNode.name?.contains("sentence")) ?? false)){
                //Otherwise, we assign it to our selectedNode.
                self.selectedNode = hitNode
                hitNode.position = position
                
                //If the user is holding a letter over the box
                if self.enterBox?.contains(position) ?? false{
                    guard let character = hitNode as? SKLabelNode else {return}
                    guard let correctLetter = currentSentence?.correctLetter else {return}
                    
                    //If the user is holding the correct letter.
                    if character.attributedText?.string.lowercased() == String(correctLetter).lowercased(){
                        guard let currentSentence = self.currentSentence else {return}
                        
                        //We reconstruct the label using the complete sentence
                        FontManager.convertToHalogen(label: sentenceLabel, text: currentSentence.sentence, fontSize: 65, withColor: ColorManager.neonGreen)
                        
                        //We removed the held node, so it seems like it was dropped into the box.
                        hitNode.removeFromParent()
                        
                        //After 1 second, we either add another sentence, or quit.
                        self.executeAfter(1, code: {
                            if let existingIndex = self.sentences.firstIndex(where: {$0 == currentSentence}){
                                self.sentences.remove(at: existingIndex)
                                if let question = self.sentences.randomElement(){
                                    self.completedQuestions += 1
                                    self.setupQuestion(question)
                                } else{
                                    //If the user has finished all questions.
                                    self.userDidFinishLevel(4)
                                }
                            }
                        })
                    } else {
                        if let answerNode = hitNode as? SKLabelNode{
                            FontManager.convertToHalogen(label: answerNode, text: answerNode.attributedText!.string, fontSize: 65, withColor: ColorManager.neonRed)
                        }
                    }
                } else {
                    if let answerNode = hitNode as? SKLabelNode{
                        FontManager.convertToHalogen(label: answerNode, text: answerNode.attributedText!.string, fontSize: 65, withColor: ColorManager.neonWhite)
                    }
                }
            }
        }
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

fileprivate struct Sentence{
    var word: String
    var sentence: String
    var missing: String
    var correctLetter: String
    var enterPosition: CGPoint
    var potentialLetters: [String]
    
    static func ==(lhs: Sentence, rhs: Sentence) -> Bool{
        return lhs.sentence == rhs.sentence
    }
}


