//
//  FanPowerVC.swift
//  Fanfinity
//
//  Created by SunTory on 2024/12/26.
//

import UIKit

class FanPowerVC: UIViewController {

    @IBOutlet weak var txtPowerConsumptioninWatts: UITextField!
    @IBOutlet weak var txtEnterDurationinHours: UITextField!
    @IBOutlet weak var txtEnterPowerFactor: UITextField!
    @IBOutlet weak var btnA: UIButton!
    @IBOutlet weak var btnB: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        btnA.layer.cornerRadius = 20
        btnB.layer.cornerRadius = 20
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reset(_ sender: Any) {
        self.view.endEditing(true)
        txtPowerConsumptioninWatts.text = ""
        txtEnterDurationinHours.text = ""
        txtEnterPowerFactor.text = ""
    }
    
    @IBAction func calculate(_ sender: Any) {
        self.view.endEditing(true)
        guard let powerText = txtPowerConsumptioninWatts.text,
              let power = Double(powerText),
              let durationText = txtEnterDurationinHours.text,
              let duration = Double(durationText),
              let powerFactorText = txtEnterPowerFactor.text,
              let powerFactor = Double(powerFactorText) else {
            showAlert(message: "Please enter valid values for all fields.")
            return
        }
        
        // Calculate the energy consumption
        let energyConsumption = power * duration * powerFactor
        let formattedEnergy = String(format: "%.2f kWh", energyConsumption / 1000) // Convert to kWh
        
        // Show result in a popup
        showResultPopup(with: formattedEnergy)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Fanfinity", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showResultPopup(with result: String) {
        // Create the popup
        let popup = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        // Add an image to the popup
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.image = UIImage(named: "fan_image") // Replace with your fan image name
        imageView.contentMode = .scaleAspectFit
        
        // Add the image as a subview
        let containerView = UIViewController()
        containerView.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.centerXAnchor.constraint(equalTo: containerView.view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: containerView.view.topAnchor)
        ])
        
        popup.setValue(containerView, forKey: "contentViewController")
        
        // Add result label
        let message = "Calculated Energy Consumption: \(result)"
        popup.message = message
        
        // Add buttons
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
        
        let copyAction = UIAlertAction(title: "Copy", style: .default) { _ in
            UIPasteboard.general.string = message
            self.showAlert(message: "Energy consumption result has been copied to clipboard.")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        popup.addAction(shareAction)
        popup.addAction(copyAction)
        popup.addAction(cancelAction)
        
        present(popup, animated: true, completion: nil)
    }
}

