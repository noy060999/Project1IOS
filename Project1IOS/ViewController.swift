//
//  ViewController.swift
//  Project1IOS
//
//  Created by user167523 on 5/6/20.
//  Copyright © 2020 NoyD. All rights reserved.
//

import UIKit
let MOVES_CONST = 20
class ViewController: UIViewController {
    
    @IBOutlet weak var game_BTN_start: UIButton!
    @IBOutlet weak var game_LBL_moves: UILabel!
    @IBOutlet weak var game_LBL_timer: UILabel!
    
    @IBOutlet weak var game_BTN_card00: UIButton!
    @IBOutlet weak var game_BTN_card01: UIButton!
    @IBOutlet weak var game_BTN_card02: UIButton!
    @IBOutlet weak var game_BTN_card03: UIButton!
    @IBOutlet weak var game_BTN_card10: UIButton!
    @IBOutlet weak var game_BTN_card11: UIButton!
    @IBOutlet weak var game_BTN_card12: UIButton!
    @IBOutlet weak var game_BTN_card13: UIButton!
    @IBOutlet weak var game_BTN_card20: UIButton!
    @IBOutlet weak var game_BTN_card21: UIButton!
    @IBOutlet weak var game_BTN_card22: UIButton!
    @IBOutlet weak var game_BTN_card23: UIButton!
    @IBOutlet weak var game_BTN_card30: UIButton!
    @IBOutlet weak var game_BTN_card31: UIButton!
    @IBOutlet weak var game_BTN_card32: UIButton!
    @IBOutlet weak var game_BTN_card33: UIButton!
    @IBOutlet weak var game_BTN_color: UIView!
    
    
    let images = [#imageLiteral(resourceName: "pluto"),#imageLiteral(resourceName: "pluto"),#imageLiteral(resourceName: "donald"),#imageLiteral(resourceName: "donald"),#imageLiteral(resourceName: "minnie"),#imageLiteral(resourceName: "minnie"),#imageLiteral(resourceName: "mickey"),#imageLiteral(resourceName: "mickey"),#imageLiteral(resourceName: "mickyminnie"),#imageLiteral(resourceName: "mickyminnie"),#imageLiteral(resourceName: "goofi"),#imageLiteral(resourceName: "goofi"),#imageLiteral(resourceName: "daisy"),#imageLiteral(resourceName: "daisy"),#imageLiteral(resourceName: "donalddaisy"),#imageLiteral(resourceName: "donalddaisy")]
    let line = [0,0,0,0]
    var imageBoardByPlaces = [[Int]]()
    var counterClicks: Int = 0
    var moves : Int = MOVES_CONST
    var matches : Int = 0
    var time = 0
    var timer = Timer()
    
    var flipedIndex: (Int,Int) = (-1,-1)
    var fliped = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game_LBL_moves.text = String(moves)
        makeAllBtnsDisabled()
        game_BTN_start.isEnabled = true
        game_BTN_color.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.07825255885, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    //init the board (when click "start" button)
    @IBAction func initGameBoard(_ sender: Any) {
        resetBoard(gameBoard: makeGameboard())
        shuffleCards(gameBoard: makeGameboard())
        game_BTN_start.isEnabled = false
        game_BTN_color.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    //new game
    func resetBoard(gameBoard: [[UIButton]]){
        time = 0
        moves = MOVES_CONST
        matches = 0
        counterClicks = 0
        fliped.removeAll()
        game_LBL_moves.text = String(moves)
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
        for line in gameBoard{ //set the hide card image
            for card in line{
                card.isEnabled = true
                card.setImage(#imageLiteral(resourceName: "logo"), for: .normal)
            }
        }
    }
    
    //when any button is click
    @IBAction func btnClicked (_ sender: UIButton){
        if (fliped.count == 1 || fliped.count == 0 ){
            //get the flipping index
            flipedIndex.0 = (sender.tag)/10
            flipedIndex.1 = (sender.tag)%10
            UIView.transition(with: sender, duration: 0.5, options: .transitionFlipFromRight,
                              animations: nil, completion: nil)
            flipCard(gameBoard: makeGameboard(), flipedIndex: flipedIndex) //flip the actual card
        }
    }
    
    func flipCard(gameBoard: [[UIButton]], flipedIndex: (Int,Int)) {
        let indexOfImage = imageBoardByPlaces[flipedIndex.0][flipedIndex.1]
        gameBoard[flipedIndex.0][flipedIndex.1].setImage(images[indexOfImage], for: .normal) //set the image
        fliped.append(gameBoard[flipedIndex.0][flipedIndex.1]) //add to flipped cards
        counterClicks += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            self.checkIfCardsMatch() //check if both cards matches
        })
        
    }
    
    func makeGameboard() -> [[UIButton]] {
        let line1 = [game_BTN_card00,game_BTN_card01,game_BTN_card02,game_BTN_card03]
        let line2 = [game_BTN_card10,game_BTN_card11,game_BTN_card12,game_BTN_card13]
        let line3 = [game_BTN_card20,game_BTN_card21,game_BTN_card22,game_BTN_card23]
        let line4 = [game_BTN_card30,game_BTN_card31,game_BTN_card32,game_BTN_card33]
        let gameBoard = [line1,line2,line3,line4]
        return gameBoard as! [[UIButton]]
    }
    
    func checkIfCardsMatch(){
        if counterClicks == 2 {
            moves -= 1
            game_LBL_moves.text = String(moves)
            if moves <= 0 && checkIfUserWin() == false{
                timer.invalidate()
                game_LBL_moves.textAlignment = .center
                game_LBL_moves.text = "Game Over!"
                game_BTN_start.isEnabled = true
                game_BTN_color.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.07825255885, alpha: 1)
                makeAllBtnsDisabled()
            }else {
                if fliped[0].currentImage == fliped[1].currentImage { //check images behind the cards
                    matches += 1
                    fliped[0].isEnabled = false
                    fliped[1].isEnabled = false
                    fliped.removeAll()
                    counterClicks = 0
                    let win: Bool  = checkIfUserWin()
                    if win == true{
                        timer.invalidate()
                        game_LBL_moves.textAlignment = .center
                        game_LBL_moves.text = "YOU WON!"
                        game_BTN_start.isEnabled = true
                        game_BTN_color.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.07825255885, alpha: 1)
                        makeAllBtnsDisabled()
                    }
                }
                else {
                    UIView.transition(with: fliped[0], duration: 0.5, options: .transitionFlipFromLeft,
                                      animations: nil, completion: nil)
                    UIView.transition(with: fliped[1], duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
                    //return to hide image
                    fliped[0].setImage(#imageLiteral(resourceName: "logo"), for: .normal)
                    fliped[1].setImage(#imageLiteral(resourceName: "logo"), for: .normal)
                    fliped.removeAll()
                    counterClicks = 0
                }
            }
        }
    }
    
    func makeAllBtnsDisabled() {
        for line in makeGameboard(){
            for card in line {
                card.isEnabled = false
            }
        }
    }
    
    @objc func updateTimer(){
        time += 1
        game_LBL_timer.text = "Time: " + String(time)
    }
    
    //shuffle all cards when clicking start button
    func shuffleCards(gameBoard: [[UIButton]]){
        var set: Set = Set<String>()
        repeat{ //shuffle the numbers
            for line in gameBoard{
                for card in line{
                    let rand1 = Int.random(in: 0..<gameBoard[0].count)
                    let rand2 = Int.random(in: 0..<gameBoard[0].count)
                    set.insert(String(rand1)+String(rand2))
                }
            }
        }while(set.count != images.count)
        
        imageBoardByPlaces = [line,line,line,line]
        var placeOfImage: Int = 0
        repeat{
            for i in 0..<set.count {
                let place: String = set[set.index(set.startIndex,offsetBy: i)]
                let placeX: Character = place.first!
                let placeY: Character = place.last!
                let placeXint: Int = Int(String(placeX))!
                let placeYint: Int = Int(String(placeY))!
                imageBoardByPlaces[placeXint][placeYint] = placeOfImage
                placeOfImage += 1
            }
        }while(placeOfImage < images.count-1)
        
    }
    
    //check if the user has all matches
    func checkIfUserWin() -> Bool{
        if matches == 8{
            return true
        }
        return false
    }
    
}



