//
//  ViewController.swift
//  MarsPhotoApp-MiraPhilip
//
//  Created by Mira Philip on 2023-07-23.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, NetworkingDelegate {
    
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var roverPicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var photoCountLabel: UILabel!
    @IBOutlet weak var imageIdPicker: UIPickerView!
    var marsPhotos: [Photo] = [Photo]()
    let rovers = ["Curiosity", "Opportunity", "Spirit"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        roverPicker.delegate = self
        roverPicker.dataSource = self
        imageIdPicker.delegate = self
        imageIdPicker.dataSource = self
        NetworkingManager.shared.delegate = self
        NetworkingManager.shared.getPhotos(earthDate: "2022-03-24", rover: "Curiosity");
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 1 ? rovers.count : marsPhotos.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == 1 ? rovers[row] : String(marsPhotos[row].id)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            NetworkingManager.shared.getPhotos(earthDate: formatDateToString(selectedDate: datePicker.date), rover: rovers[row])
        } else {
            if marsPhotos.count > 0 {
                NetworkingManager.shared.getImage(imgSrc: marsPhotos[row].img_src)
            }
        }
    }
    
    func networkingDidFinishWithPhotos(allPhotos: [Photo]) {
        marsPhotos = allPhotos
        imageIdPicker.reloadAllComponents()
        photoCountLabel.text = "Num Of Photos: \(allPhotos.count)"
    }
    
    func netwokingDidFinishWithoutPhotos() {
        print("Error fetching photos")
    }
    
    func networkingDidFinishWithDownloadImage(image: UIImage) {
        currentImage.image = image
    }
    
    func networkingDidFinishWithoutDownloadImage() {
        print("Error downloading image")
    }
    
    
    @IBAction func saveAsFavPhoto(_ sender: Any) {
        let newFavPhoto : Photo = Photo()
        let imageSelected = marsPhotos[imageIdPicker.selectedRow(inComponent: 0)]
        newFavPhoto.id = imageSelected.id
        newFavPhoto.img_src = imageSelected.img_src
        newFavPhoto.earth_date = imageSelected.earth_date
        newFavPhoto.rover.name = imageSelected.rover.name
        newFavPhoto.camera.name = imageSelected.camera.name
        FirebaseManager.shared.insertNewFavPhoto(p: newFavPhoto)
        self.navigationController!.popViewController(animated: true)
    }
    
    func formatDateToString(selectedDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: selectedDate)
    }
    
    @objc func dateChanged() {
        let selectedDate = datePicker.date
        let formattedDateString = formatDateToString(selectedDate: selectedDate)
        NetworkingManager.shared.getPhotos(earthDate: formattedDateString, rover: rovers[roverPicker.selectedRow(inComponent: 0)])
    }

    
}

