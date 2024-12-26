//
//  FanTypesVC.swift
//  Fanfinity
//
//  Created by SunTory on 2024/12/26.
//
import UIKit

class FanTypesVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
 
    @IBOutlet weak var colLVIewFan: UICollectionView!
    
    var flowLayouts: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        
        DispatchQueue.main.async {
            _flowLayout.itemSize = CGSize(width: self.colLVIewFan.frame.size.width / 2, height: 200)
            _flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            _flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
            _flowLayout.minimumInteritemSpacing = 0.0
            _flowLayout.minimumLineSpacing = 0.0
        }
        return _flowLayout
    }
    
    var arrFanTypes = [
        "Ceiling Fan", "Table Fan", "Wall Mounted Fan", "Tower Fan", "Pedestal Fan",
        "Exhaust Fan", "Industrial Fan", "Box Fan", "Bladeless Fan", "Window Fan",
        "Misting Fan", "Desk Fan", "Attic Fan", "High-Velocity Fan", "Oscillating Fan",
        "Portable Fan", "Solar Fan", "Stand Fan", "Circulator Fan", "Axial Fan"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        colLVIewFan.delegate = self
        colLVIewFan.dataSource = self
        colLVIewFan.register(UINib(nibName: "FanTypesCell", bundle: nil), forCellWithReuseIdentifier: "FanTypesCell")
        colLVIewFan.collectionViewLayout = self.flowLayouts
        navigationController?.navigationBar.isHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFanTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colLVIewFan.dequeueReusableCell(withReuseIdentifier: "FanTypesCell", for: indexPath) as! FanTypesCell
        cell.lblMain.text = arrFanTypes[indexPath.row]
        cell.viewMain.layer.cornerRadius = 20
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showPopup(for: arrFanTypes[indexPath.row])
    }
    
    func showPopup(for fanType: String) {
        let alertController = UIAlertController(title: fanType, message: "What would you like to do?", preferredStyle: .alert)
        
        // Share button
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            let activityVC = UIActivityViewController(activityItems: [fanType], applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
        }
        
        // Copy button
        let copyAction = UIAlertAction(title: "Copy", style: .default) { _ in
            UIPasteboard.general.string = fanType
            let copiedAlert = UIAlertController(title: "Copied", message: "\(fanType) has been copied to clipboard.", preferredStyle: .alert)
            self.present(copiedAlert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                copiedAlert.dismiss(animated: true)
            }
        }
        
        // Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(shareAction)
        alertController.addAction(copyAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
