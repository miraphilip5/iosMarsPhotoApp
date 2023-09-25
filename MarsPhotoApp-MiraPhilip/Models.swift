//
//  Models.swift
//  MarsPhotoApp-MiraPhilip
//
//  Created by Mira Philip on 2023-07-23.
//

import Foundation

class Photo : Codable{
    var id : Int = 0
    var sol : Int = 0
    var camera : Camera = Camera()
    var img_src: String = ""
    var earth_date: String = ""
    var rover : Rover = Rover()
    
    init(imageId: Int, imgSrc: String, earthDate : String, cameraName : String, roverName: String){
        id = imageId
        img_src = imgSrc
        earth_date = earthDate
        camera = Camera(cName: cameraName)
        rover = Rover(rName: roverName)
    }
    
    //Constructor for Firestore
    init(imgSrc: String, earthDate : String, cameraName : String, roverName: String){
        img_src = imgSrc
        earth_date = earthDate
        camera = Camera(cName: cameraName)
        rover = Rover(rName: roverName)
    }
    
    init(){}

}

class Camera : Codable {
    var name: String = ""
    var id : Int = 0
    var rover_id: Int = 0
    var full_name: String = ""
    
    init(cName: String){
        name = cName
    }
    
    init(){}
}

class Rover : Codable {
    var name: String = ""
    var id : Int = 0
    var landing_date: String = ""
    var launch_date: String = ""
    var status: String = ""
    var max_sol: Int = 0
    var max_date: String = ""
    var total_photos: Int = 0
    var cameras: [Camera1] = []
    
    init(rName: String){
        name = rName
    }
    
    init(){}
}

class Camera1 : Codable {
    var name: String = ""
    var full_name: String = ""
}

class Photos : Codable{
    var photos : [Photo] = [Photo]()
}


