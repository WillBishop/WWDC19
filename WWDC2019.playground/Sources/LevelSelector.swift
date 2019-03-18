import Foundation

//Allows us to track when the user selects a level.
protocol LevelSelector{
    func didSelectLevel(_ level: Int)
}
