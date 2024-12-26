//
//  FanVC.swift
//  Fanfinity
//
//  Created by SunTory on 2024/12/26.
//

import UIKit

class FanVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var tblView: UITableView!
    
    var arrFanImage = ["fan_1","fan_2","fan_3","fan_4","fan_5","fan_6","fan_7","fan_8","fan_9","fan_10","fan_11","fan_12","fan_13","fan_14","fan_15"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib.init(nibName: "FanCell", bundle: nil), forCellReuseIdentifier: "FanCell")
        navigationController?.navigationBar.isHidden = true
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrFanImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "FanCell") as! FanCell
        cell.imgFan.image = UIImage.init(named: arrFanImage[indexPath.row])
        cell.imgFan.layer.cornerRadius = 20
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController.init(title: "Fanfinity", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction.init(title: "Share", style: .default, handler: { alertYES in
            
            self.shareImage(image: UIImage.init(named: self.arrFanImage[indexPath.row])!)
            
        }))
        
        alert.addAction(UIAlertAction.init(title: "Download", style: .default, handler: { alertYES in
            
            let alertDelete = UIAlertController.init(title: "Fanfinity", message: "Are you sure to download wallpaper?", preferredStyle: .alert)
            alertDelete.addAction(UIAlertAction.init(title: "YES", style: .default, handler: { alertYES in
                UIImageWriteToSavedPhotosAlbum(UIImage.init(named: self.arrFanImage[indexPath.row])!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                
            }))
            alertDelete.addAction(UIAlertAction.init(title: "NO", style: .cancel))
            self.present(alertDelete, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    
    func shareImage(image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    //MARK: FUNCTIONS
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
}
