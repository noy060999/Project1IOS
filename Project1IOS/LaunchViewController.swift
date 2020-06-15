//
//  LaunchViewController.swift
//  Project1IOS
//
//  Created by user167523 on 6/13/20.
//  Copyright © 2020 NoyD. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController, GameViewControllerDelegates {
    //delegate function
    func doSomethingWith(data: Player) {
        currentPlayerInLaunch = data
    }
    
//outlets inits
    @IBOutlet weak var launch_BTN_play: UIButton!
    @IBOutlet weak var launch_BTN_topten: UIButton!
    @IBOutlet weak var launch_TXTFIELD_name: UITextField!

    
    var currentPlayerInLaunch = Player()
    var playerName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //when clicking "Play"
    @IBAction func enterGame(_ sender: Any) {
        //I used seuge methods for moving between VC's
        //set seuge identifier
        self.performSegue(withIdentifier: "launchVCtoGameVC", sender: self)
    }
    
    //prepare the suege method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //check by the seuge identifier: when going to Play:
        if (segue.identifier == "launchVCtoGameVC"){
            let gameVC = segue.destination as! ViewController
            var tempName = launch_TXTFIELD_name.text
            if (tempName == ""){
                //default name that i chose
                tempName = "player"
            }
            gameVC.delegate = self
            gameVC.currentPlayer.playerName = tempName ?? "player"
        }
        //check by the seuge identifier: when going to TopTen Page:
        if (segue.identifier == "launchVCtoToptenVC"){
                   let toptenVC = segue.destination as! TopTenViewController
                   var tempName = launch_TXTFIELD_name.text
                   if (tempName == ""){
                       tempName = "player"
                   }
                //init the current player from launch VC
                   toptenVC.currentPlayer = currentPlayerInLaunch
               }
    }

    //when clicking " Top Ten "
    @IBAction func enterTopTenPage(_ sender: Any) {
        //set seuge identifier
        self.performSegue(withIdentifier: "launchVCtoToptenVC", sender: self)

    }
}
