//: ### WWDC 2019 Scholarship Submission

//: To play the game, open the 'Assistant Editor' and choose 'Live View' in the new window.

//: This game consists of 5 levels, each focusing on a different aspect of early education.
//: 1. Mathematics
//: 2. Music
//: 3. Observational Skills
//: 4. Literacy
//: 5. Geography

import PlaygroundSupport
import SpriteKit
1

//: Here we register our font for use throught our playground.

FontManager.registerFont(withName: "halogen", andExtension: "otf")

//: Load the SKScene from 'GameScene.sks'
public class MainLoader{
    
    
    public static let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
    
    //Instantiate our two main scenes
    private static let menuScene = MenuScene(fileNamed: "GameScene")
    private static let welcomeScene = WelcomeScene(fileNamed: "WelcomeScene")
    private static let finishedScene = WelcomeScene(fileNamed: "FinishedScene")
    
    //Create our fun little plane node :)
    public static let planeLabel = SKLabelNode(text: "✈️")
    
    //Let our welcome scene, then wait 3.5 seconds and fade into the menu
    func loadMainScene(){
        guard let menuScene = MainLoader.menuScene else {
            fatalError("Could not find main scene")
        }
        guard let welcomeScene = MainLoader.welcomeScene else {
            fatalError("Could not find welcome scene")
        }
        // Set the scale mode to scale to fit the window
        menuScene.scaleMode = .aspectFill
        MainLoader.setupPlane()
        MainLoader.sceneView.presentScene(welcomeScene)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5, execute: {
            // Present the scene
            MainLoader.sceneView.presentScene(menuScene, transition: SKTransition.crossFade(withDuration: 1.0))
            menuScene.loadLevel = { level in
                MainLoader.startLevel(level)
            }
            menuScene.getHelpForLevel = { level in
                MainLoader.getHelpForLevel(level)
            }
        })
        
        //When we're 'ready', we call ready(), which turns on the live view.
        self.ready()
        
        
    }
    
    public static func setupPlane(){
        
        //This ensures our plane is above all other elements
        MainLoader.planeLabel.zPosition = 100
        
        //Set our font size to a good size
        MainLoader.planeLabel.fontSize = 40.0
    
        //Move it to the start of our first path, just before the first level.
        MainLoader.planeLabel.run(SKAction.move(to: CGPoint(x: (menuScene?.startLabel.frame.maxX)! - 2, y: (menuScene?.startLabel.frame.midY)! - 2), duration: 0))
        
        //Rotate it to the angle of the line
        MainLoader.planeLabel.run(SKAction.rotate(toAngle: -0.6, duration: 0))
        menuScene?.addChild(MainLoader.planeLabel)

    }
    public static func getHelpForLevel(_ level: Int){
        guard let helpScene = HelpScene(fileNamed: "HelpScene") else {return}
        helpScene.scaleMode = .aspectFill
        helpScene.quit = MainLoader.quit
        switch level{
        case 0: //Menu
            helpScene.title = "Menu"
            helpScene.subtitle = "Click a level with your mouse to start"
        default:
            helpScene.title = "Help"
            helpScene.subtitle = ""
        }
       print("Presenting")
        MainLoader.sceneView.presentScene(helpScene, transition: SKTransition.fade(withDuration: 0.5))
        
    }
    
    public static func startLevel(_ level: Int){
        switch level{
        case 1:
            MainLoader.movePlaneTo(level: 1, finished: {
                MainLoader.menuScene?.animateInto(level: 1, finished: {
                    guard let levelScene = LevelOneScene(fileNamed: "Level\(level)") else {
                        fatalError("Could not find Level \(level)")
                    }
                    
                    levelScene.quit = MainLoader.quit
                    levelScene.userDidFinishLevel = MainLoader.userDidFinishLevel
                    print("Presenting")
                    levelScene.scaleMode = .aspectFill
                    MainLoader.sceneView.presentScene(levelScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1))
                })
                
            })
            
        case 2:
            MainLoader.menuScene?.animateInto(level: 2, finished: {
                guard let levelScene = LevelTwoScene(fileNamed: "Level\(level)") else {
                    fatalError("Could not find Level \(level)")
                }
                levelScene.quit = MainLoader.quit
                levelScene.userDidFinishLevel = self.userDidFinishLevel
                print("Presenting")
                levelScene.scaleMode = .aspectFill
                MainLoader.sceneView.presentScene(levelScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1))
            })
        case 3:
            MainLoader.menuScene?.animateInto(level: 3, finished: {
                guard let levelScene = LevelThreeScene(fileNamed: "Level\(level)") else {
                    fatalError("Could not find Level \(level)")
                }
                levelScene.quit = MainLoader.quit
                levelScene.userDidFinishLevel = self.userDidFinishLevel
                print("Presenting")
                levelScene.scaleMode = .aspectFill
                MainLoader.sceneView.presentScene(levelScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1))
            })
            print("Loading Level 3")
        case 4:
            MainLoader.menuScene?.animateInto(level: 4, finished: {
                guard let levelScene = LevelFourScene(fileNamed: "Level\(level)") else {
                    fatalError("Could not find Level \(level)")
                }
                levelScene.quit = MainLoader.quit
                levelScene.userDidFinishLevel = self.userDidFinishLevel
                print("Presenting")
                levelScene.scaleMode = .aspectFill
                MainLoader.sceneView.presentScene(levelScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1))
            })
        case 5:
            MainLoader.menuScene?.animateInto(level: 5, finished: {
                guard let levelScene = LevelFiveScene(fileNamed: "Level\(level)") else {
                    fatalError("Could not find Level \(level)")
                }
                levelScene.quit = MainLoader.quit
                levelScene.userDidFinishLevel = self.userDidFinishLevel
                print("Presenting")
                levelScene.scaleMode = .aspectFill
                MainLoader.sceneView.presentScene(levelScene, transition: SKTransition.doorsOpenHorizontal(withDuration: 1))
            })
        default:
            fatalError("Could not find Level \(level)")
        }
    }
    
    public static var quit: () -> Void = {
        MainLoader.quitLevel()
        
    }
    
    static func movePlaneTo(level: Int, finished: @escaping () -> Void){
        switch level{
        case 1:
            MainLoader.planeLabel.run(SKAction.rotate(toAngle: -0.6, duration: 0), completion: {
            })
        case 2:
            MainLoader.planeLabel.run(SKAction.rotate(toAngle: -0.5, duration: 0), completion: {
            })
        case 3:
            MainLoader.planeLabel.run(SKAction.rotate(toAngle: 1.7, duration: 0), completion: {
            })
        case 4:
            MainLoader.planeLabel.run(SKAction.rotate(toAngle: 1.3, duration: 0), completion: {
            })
        case 5:
            MainLoader.planeLabel.run(SKAction.rotate(toAngle: -0.8, duration: 0), completion: {
            })
        case 6:
            MainLoader.planeLabel.run(SKAction.rotate(toAngle: -0.5, duration: 0), completion: {
            })
        default:
            print()
        }
        MainLoader.planeLabel.run(SKAction.follow(MainLoader.menuScene!.levelPaths[level - 1], asOffset: false, orientToPath: false, duration: 2.0), completion: {
            finished()
        })
    }
    
    public static var userDidFinishLevel: (Int) -> Void = {level in
        print("Finished \(level)")
        menuScene?.levels[level - 1].associatedLabel?.fontColor = ColorManager.neonGreen

        switch level{
        case 1:
            MainLoader.movePlaneTo(level: 2, finished: {
                MainLoader.startLevel(2)
            })
        case 2:
            MainLoader.movePlaneTo(level: 3, finished: {
                MainLoader.startLevel(3)
            })
        case 3:
            MainLoader.movePlaneTo(level: 4, finished: {
                MainLoader.startLevel(4)
            })
        case 4:
            MainLoader.movePlaneTo(level: 5, finished: {
                MainLoader.startLevel(5)
            })
        case 5:
            MainLoader.movePlaneTo(level: 6, finished: {
               print("Presenting")
                guard let finishedScene = MainLoader.finishedScene else {return}
                MainLoader.sceneView.presentScene(finishedScene, transition: SKTransition.crossFade(withDuration: 1.0))

            })
        default:
            print("Finished another level")
        }
        MainLoader.quitLevel()
    }
    
    public static func quitLevel(){
        guard let scene = MainLoader.menuScene else {
            fatalError("Could not find main scene")
        }
        sceneView.presentScene(scene, transition: SKTransition.doorsCloseHorizontal(withDuration: 1))
        let moveAction = SKAction.move(to: CGPoint(x: 0, y: 0), duration: 0.75)
        let zoomAction = SKAction.scale(to: 1.0, duration: 0.75)
        scene.zoomed = false
        scene.camera?.run(moveAction)
        scene.camera?.run(zoomAction)
    }
    func ready(){
        PlaygroundSupport.PlaygroundPage.current.liveView = MainLoader.sceneView
        
    }
}

MainLoader().loadMainScene()

