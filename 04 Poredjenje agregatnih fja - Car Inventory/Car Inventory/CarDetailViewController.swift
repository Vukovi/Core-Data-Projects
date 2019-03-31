//
//  CarDetailViewController.swift
//  Car Inventory
//
//  Created by Andi Setiyadi on 9/3/16.
//  Copyright © 2016 devhubs. All rights reserved.
//

import UIKit

class CarDetailViewController: UIViewController {

    var car: Car!
    var specs: Specification!
    
    // MARK: Outlets
    
    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carPriceLabel: UILabel!
    @IBOutlet weak var carHpLabel: UILabel!
    @IBOutlet weak var carMpgLabel: UILabel!
    @IBOutlet weak var carSafetyLabel: UILabel!
    @IBOutlet weak var carConditionLabel: UILabel!
    @IBOutlet weak var carTypeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let carImage = car.carImage!
        carImageView.image = UIImage(data: carImage.image! as Data)
        carNameLabel.text = "\(car.year) \(car.make!) \(car.model!)"
        carPriceLabel.text = car.price.currencyFormatter
        
        specs = car.specs
        carHpLabel.text = String(specs.horsepower)
        carMpgLabel.text = String(specs.avgFuel)
        carSafetyLabel.text = String(specs.safetyRating)
        carConditionLabel.text = String(specs.conditionRating)
        carTypeLabel.text = specs.type
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
