//
//  FavPhotoDetailViewController.swift
//  MarsPhotoApp-MiraPhilip
//
//  Created by Mira Philip on 2023-07-23.
//

import UIKit

class FavPhotoDetailViewController: UIViewController, NetworkingDelegate {

    @IBOutlet weak var favImage: UIImageView!
    @IBOutlet weak var earthDateLabel: UILabel!
    @IBOutlet weak var roverLabel: UILabel!
    @IBOutlet weak var cameraLabel: UILabel!
    
    var photo : Photo = Photo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkingManager.shared.delegate = self
        NetworkingManager.shared.getImage(imgSrc: photo.img_src)
    }

    func networkingDidFinishWithDownloadImage(image: UIImage) {
        favImage.image = image
        earthDateLabel.text = "Earth Date: \(photo.earth_date)"
        roverLabel.text = "Rover : \(photo.rover.name)"
        cameraLabel.text = "Camera : \(photo.camera.name)"
    }
    
    func networkingDidFinishWithoutDownloadImage() {
        print("Image download error")
    }
    
    func networkingDidFinishWithPhotos(allPhotos: [Photo]) {
        
    }
    
    func netwokingDidFinishWithoutPhotos() {
        
    }
}
