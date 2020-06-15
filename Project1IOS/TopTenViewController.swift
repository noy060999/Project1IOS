//
//  TopTenViewController.swift
//  Project1IOS
//
//  Created by user167523 on 6/13/20.
//  Copyright © 2020 NoyD. All rights reserved.
//

import UIKit
import MapKit

//my custom pin class
class customPin: NSObject,MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(myTitle:String,mySubtitle:String,myCoordinate:CLLocationCoordinate2D) {
        self.coordinate = myCoordinate
        self.title = myTitle
        self.subtitle = mySubtitle
    }
    
}

class TopTenViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let cellReuseID = "cell"
    var topPlayers = [Player]()
    var topPlayersNames = [String]()
    //Tel Aviv location
    let initialLocation = CLLocation(latitude: 32.0853, longitude: 34.7818)
    
    
    @IBOutlet weak var topten_Table: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var homeScreen_btn: UIButton!
    var currentPlayer = Player()
    override func viewDidLoad() {
        super.viewDidLoad()
        //support dark theme mode
        overrideUserInterfaceStyle = .dark
        self.topten_Table.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseID)
        topten_Table.delegate = self
        topten_Table.dataSource = self
        
        //PRINTING (FOR ME)
        //print("when entering topten , name: \(currentPlayer.playerName) time:\(currentPlayer.timeToFinishGame) moves: \(currentPlayer.movesPerGame) ")
        
        if (currentPlayer.movesPerGame == -1){
            currentPlayer.movesPerGame = 0
        }
        let topPlayersDefault = UserDefaults.standard
        if (topPlayersDefault.value(forKey: "key3") != nil){
            topPlayersNames = topPlayersDefault.value(forKey: "key3") as! [String]
        }
        if(currentPlayer.timeToFinishGame != 0){
            addToTopPlayers()
        }
        topPlayersNames = makeNamesList(players: topPlayers)
        
        //PRINING (FOR ME)
//        for i in 0..<topPlayersNames.count{
//            print("player: \(topPlayersNames[i])")
//
//        }
        
        setMapViewAnnotations()
    
    }
    
    //add the pins to the mapView - i used random locations in Tel Aviv :)
    func setMapViewAnnotations(){
        mapView.centerToLocation(initialLocation)
        let telAvivCenter = CLLocationCoordinate2D(latitude: 32.0853, longitude: 34.7818)
        let bananaBeach = CLLocationCoordinate2D(latitude: 32.0703693, longitude: 34.760067)
        let habima = CLLocationCoordinate2D(latitude: 32.070369, longitude: 34.7535009)
        let evenGvirol = CLLocationCoordinate2D(latitude: 32.0865323, longitude: 34.7842548)
        let dizengofCenter = CLLocationCoordinate2D(latitude: 32.0750224, longitude: 34.7771282)
        let azrieli = CLLocationCoordinate2D(latitude: 32.0740769, longitude: 34.7943915)
        let alenby = CLLocationCoordinate2D(latitude: 32.0676462, longitude: 34.7733892)
        let usaAgency = CLLocationCoordinate2D(latitude: 32.0767352, longitude: 34.7688893)
        let lunaPark = CLLocationCoordinate2D(latitude: 32.106497, longitude: 34.8140697)
        let afeka = CLLocationCoordinate2D(latitude: 32.1226142, longitude: 34.8152908)
        
        let region = MKCoordinateRegion(
            center: telAvivCenter,
            latitudinalMeters: 50000,
            longitudinalMeters: 60000)
        mapView.setCameraBoundary(
            MKMapView.CameraBoundary(coordinateRegion: region),
            animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 600000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        let rotchild = customPin(myTitle: "Rotchild blvd",mySubtitle: "Tel Aviv",myCoordinate: telAvivCenter)
        let bananaBeachPin = customPin(myTitle: "Banana Beach", mySubtitle: "Tel Aviv", myCoordinate: bananaBeach)
        let habimaPin = customPin(myTitle: "Habima",mySubtitle: "Tel Aviv",myCoordinate: habima)
        let evenGvirolPin = customPin(myTitle: "Ibn Gvirol",mySubtitle: "Tel Aviv",myCoordinate: evenGvirol)
        let dizengofCenterPin = customPin(myTitle: "Dizengof Center",mySubtitle: "Tel Aviv",myCoordinate: dizengofCenter)
        let azrieliPin = customPin(myTitle: "Azrieli center",mySubtitle: "Tel Aviv",myCoordinate: azrieli)
        let alenbyPin = customPin(myTitle: "Alenby st.",mySubtitle: "Tel Aviv",myCoordinate: alenby)
        let usaAgencyPin = customPin(myTitle: "USA Agency",mySubtitle: "Tel Aviv",myCoordinate: usaAgency)
        let lunaParkPin = customPin(myTitle: "Luna Park",mySubtitle: "Tel Aviv",myCoordinate: lunaPark)
        let afekaPin = customPin(myTitle: "Afeka College",mySubtitle: "Tel Aviv",myCoordinate: afeka)
        
        mapView.addAnnotation(rotchild)
        mapView.addAnnotation(bananaBeachPin)
        mapView.addAnnotation(habimaPin)
        mapView.addAnnotation(evenGvirolPin)
        mapView.addAnnotation(dizengofCenterPin)
        mapView.addAnnotation(azrieliPin)
        mapView.addAnnotation(alenbyPin)
        mapView.addAnnotation(usaAgencyPin)
        mapView.addAnnotation(lunaParkPin)
        mapView.addAnnotation(afekaPin)
        
    }
    
    //homeScreen btn action
    @IBAction func backToHome(_ sender: Any) {
        let topPlayersDefault = UserDefaults.standard
        topPlayersDefault.setValue(topPlayersNames, forKey: "key3")
        topPlayersDefault.synchronize()
        self.dismiss(animated: true, completion: nil)
    }
    
    //table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topPlayersNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = topten_Table.dequeueReusableCell(withIdentifier: cellReuseID) ?? UITableViewCell(style: .default, reuseIdentifier: "cell") as UITableViewCell
        cell.textLabel?.text = self.topPlayersNames[indexPath.row]
        return cell
    }
    
    
    //sort the players by their time
    func sortTopPlayers(topPlayers: [Player]) -> [Player]{
        topPlayers.sorted { $0.timeToFinishGame > $1.timeToFinishGame }
    }
    
    func addToTopPlayers(){
        if (topPlayers.count <= 10){
            topPlayers.append(currentPlayer)
            topPlayers = sortTopPlayers(topPlayers: topPlayers)
        }
        else{
            //if there are more than 10 games
            if (currentPlayer.timeToFinishGame < topPlayers[9].timeToFinishGame) {
                topPlayers.remove(at: 9)
                topPlayers.append(currentPlayer)
                topPlayers = sortTopPlayers(topPlayers: topPlayers)
            }
        }
    }
    
    //make name list out of the top players list, to send to the userDefaults
    func makeNamesList(players: [Player]) -> [String]{
        for i in 0..<players.count{
            topPlayersNames.append(players[i].playerName)
        }
        return topPlayersNames
    }
    
}

//mapView extension
private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
