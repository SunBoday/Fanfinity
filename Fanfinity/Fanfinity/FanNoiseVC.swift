//
//  FanNoiseVC.swift
//  Fanfinity
//
//  Created by SunTory on 2024/12/26.
//

import UIKit

class FanNoiseVC: UIViewController {

    @IBOutlet weak var txtSoundPressureLevelindB: UITextField!
    @IBOutlet weak var txtEnterDistanceinmeters: UITextField!
    @IBOutlet weak var btnA: UIButton!
    @IBOutlet weak var btnB: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnA.layer.cornerRadius = 20
        btnB.layer.cornerRadius = 20
        navigationController?.navigationBar.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func tapBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reset(_ sender: Any) {
        self.view.endEditing(true)
        txtSoundPressureLevelindB.text = ""
        txtEnterDistanceinmeters.text = ""
    }
    
    @IBAction func calculate(_ sender: Any) {
        self.view.endEditing(true)
        guard let pressureText = txtSoundPressureLevelindB.text,
              let pressure = Double(pressureText),
              let distanceText = txtEnterDistanceinmeters.text,
              let distance = Double(distanceText) else {
            showAlert(message: "Please enter valid values for Sound Pressure and Distance.")
            return
        }
        
        // Calculate the noise level using the formula
        let referencePressure: Double = 0.00002 // Reference pressure in Pascals
        let SPL = 20 * log10(pressure / referencePressure) - 20 * log10(distance)
        let formattedSPL = String(format: "%.2f dB", SPL)
        
        // Show result in a popup
        showResultPopup(with: formattedSPL)
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
        let message = "Calculated Noise Level: \(result)"
        popup.message = message
        
        // Add buttons
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            let activityVC = UIActivityViewController(activityItems: [message], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
        
        let copyAction = UIAlertAction(title: "Copy", style: .default) { _ in
            UIPasteboard.general.string = message
            self.showAlert(message: "Noise level has been copied to clipboard.")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        popup.addAction(shareAction)
        popup.addAction(copyAction)
        popup.addAction(cancelAction)
        
        present(popup, animated: true, completion: nil)
    }
}
