//
//  ChangeCityViewController.swift
//  OWA
//
//  Created by Leart on 2/2/19.
//  Copyright © 2019 RudiLeart. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnteredCityName (cityName: String)
}

class ChangeCityViewController: UIViewController {
    
    var delegate: ChangeCityDelegate?

    @IBOutlet weak var changeCityTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func getWeatherBtnPressed(_ sender: UIButton) {
        let city = changeCityTF.text!
        let cityName = city.replacingOccurrences(of: " ", with: "+")
        delegate?.userEnteredCityName(cityName: cityName)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
