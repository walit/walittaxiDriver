//
//  HomeViewController.swift
//  Walit Driver
//
//  Created by Arjun on 3/3/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import GoogleMaps
import SocketIO
import AVFoundation
class HomeViewController: UIViewController {
    
    @IBOutlet weak var viewdirection: UIView!
    
    @IBOutlet weak var noCurrentTask: UIView!
    @IBOutlet weak var lblDriverName: UILabel!
    
    @IBOutlet weak var lblDriverName1: UILabel!
    
    
    @IBOutlet weak var viewMap: GMSMapView!
    @IBOutlet weak var viewStartRide: UIView!
    @IBOutlet weak var viewEndRide: UIView!
    @IBOutlet weak var viewOtp: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var imgCustomer: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblDiscount1: UILabel!
    @IBOutlet weak var lblPickupnew: UILabel!
    @IBOutlet weak var lblDropoffNew: UILabel!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var txtOTP: UITextField!
    
    
    
    // Start Ride View
    
    @IBOutlet weak var lblStartUserName: UILabel!
    @IBOutlet weak var lblStartRidedorpOff: UILabel!
    @IBOutlet weak var lblStartRidePickup: UILabel!
    @IBOutlet weak var lblStartPrice: UILabel!
    @IBOutlet weak var lblStartDistance: UILabel!
    
    
    // End Ride
    @IBOutlet weak var lblEndDropOff: UILabel!
    @IBOutlet weak var lblEndDistance: UILabel!
    @IBOutlet weak var lblRideTime: UILabel!
    
    // cancel ride
    @IBOutlet weak var viewCancelReason: UIView!
    @IBOutlet weak var txtCancelReason: UITextField!
    
    
    var requestID = String()
    var rideID = String()
    var request = Request()
    var objPlayer: AVAudioPlayer?
    let manager = SocketManager.init(socketURL: URL(string:"http://132.148.145.112:2022")!, config: [.log(true), .compress])
    var socket:SocketIOClient!
    
    //var acceptRequest  = AcceptRequest()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewdirection.isHidden = true
        self.getHomeData()
        socket = manager.defaultSocket
        socket.connect()
        
        lblDriverName.text = Global.sharedInstance.user.first_name + " "  + Global.sharedInstance.user.last_name
        noCurrentTask.isHidden = false
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.batteryLevelChanged),
            name: Notification.Name("updatelocation"),
            object: nil)
      
    }
    @objc private func batteryLevelChanged(notification: NSNotification){
        //do stuff using the userInfo property of the notification object
        DispatchQueue.main.async {
            NotificationCenter.default.removeObserver(self)
            let camera = GMSCameraPosition.camera(withLatitude: LocationManager.manager.latitude, longitude: LocationManager.manager.longitude, zoom: 15.0)
            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            mapView.isMyLocationEnabled = true
            self.viewMap.camera = camera
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        self.scrollView.isHidden = true
        self.viewButton.isHidden = true
        viewOtp.isHidden = true
        viewEndRide.isHidden = true
        viewStartRide.isHidden = true
        socket.on(clientEvent: .connect) { (data, ack) in
            
            self.connectSocket()
        }
    }
    func connectSocket(){
        
        socket.on("get new request") { (items, ackEmitter) in
            self.playAudioFile()
            print(items)
            self.getHomeData()
        }
        socket.on("get user cancel ride") { (items, ackEmitter) in
            self.viewStartRide.isHidden = true
            self.viewdirection.isHidden = true
            Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Sorry", alertMessage: "Customer cancel ride")
        }
        
      
    }
    
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        self.imgCustomer.layer.cornerRadius = self.imgCustomer.frame.height / 2
        self.imgCustomer.clipsToBounds = true
    }
    
    @IBAction func btnRefresh(_ sender: Any) {
        self.getHomeData()
    }
    @IBAction func btnHome(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setData"), object: nil, userInfo: nil)
    }
    
    @IBAction func btnDirection(_ sender: Any) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
        {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=&daddr=\(self.request.destination_latitude ?? ""),\(self.request.destination_longitude ?? "")&directionsmode=driving")! as URL)
        } else
        {
            let url = "http://maps.apple.com/maps?saddr=\(self.request.origin_latitude ?? ""),\(self.request.origin_longitude ?? "")&daddr=\(self.request.destination_latitude ?? ""),\(self.request.destination_longitude ?? "")"
            UIApplication.shared.openURL(URL(string:url)!)
            
        }
    }
    
    
    @IBAction func btnAcceptNewOrder(_ sender: Any) {
        self.scrollView.isHidden = true
        viewButton.isHidden = true
        self.acceptRequest(requestID: self.request.request_id)
    }
    @IBAction func btnRejectNewOrder(_ sender: Any) {
        self.scrollView.isHidden = true
        viewButton.isHidden = true
        self.cancelRequest(requestID: self.request.request_id)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        viewStartRide.isHidden = true
        viewdirection.isHidden = true
        let alert = UIAlertController(title: title, message: "Are you sure you want to cancel this Ride?", preferredStyle: .alert)
        let ok = UIAlertAction(title: "YES", style: .default, handler: { action in
            self.viewCancelReason.isHidden = false
        })
        let cancel = UIAlertAction(title: "NO", style: .default, handler: { action in
            self.viewStartRide.isHidden = false
            self.viewdirection.isHidden = false
        })
        alert.addAction(ok)
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
    
    @IBAction func btnCall(_ sender: Any) {
    }
    
    @IBAction func btnCancelReasonOk(_ sender: Any) {
        self.viewCancelReason.isHidden = true
        self.view.endEditing(true)
        self.cancelRide(ride_id: rideID, reason: self.txtCancelReason.text!)
    }
    
    @IBAction func btnStartRide(_ sender: Any) {
        self.viewOtp.isHidden = false
        self.viewStartRide.isHidden = true
       
    }
    
    @IBAction func btnOTPOk(_ sender: Any) {
       self.verifyOTP()
    }
    @IBAction func btnEndRide(_ sender: Any) {
        self.endRide(requestID: self.rideID)
    }
    @IBAction func btnCancelRideView(_ sender: Any) {
        self.viewOtp.isHidden = true
        self.viewStartRide.isHidden = false
        viewdirection.isHidden = false
    }
   
    func getHomeData(){
        HomeHandler.manager.getHomePageDetails(completion: {json,success,error,typeStr in
            DispatchQueue.main.async {
                if success == true {
                    self.noCurrentTask.isHidden = true
                    self.request.getData(dict: json)
                    self.lblPickupnew.text = self.request.origin_address
                    self.lblDropoffNew.text = self.request.destination_address
                    self.lblUserName.text = self.request.customer_first_name + self.request.customer_last_name
                    self.lblAmount.text =  self.request.total_paid_price
                    self.lblDistance.text = self.request.second_milestone_distance_text
                    
                    let strImage = self.request.customer_image_url
                    
                    let myURL = strImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    
                    if let url = URL(string: myURL!) {
                        self.imgCustomer.af_setImage(withURL: url)
                    }
                    else{
                        self.imgCustomer.image = #imageLiteral(resourceName: "uploadUser")
                    }
                    self.lblStartUserName.text = self.request.customer_first_name + " " + self.request.customer_last_name
                    self.lblStartRidePickup.text = self.request.origin_address
                    self.lblStartRidedorpOff.text = self.request.destination_address
                    self.lblStartPrice.text =  self.request.total_paid_price
                    self.lblStartDistance.text = self.request.second_milestone_distance_text
                    self.lblEndDropOff.text = self.request.origin_address
                    self.lblEndDistance.text = self.request.second_milestone_distance_text
                     self.lblRideTime.text = self.request.second_milestone_duration_text
                    
                    //
                    let slang = Double(self.request.origin_latitude)
                    let slong = Double(self.request.origin_longitude)
                    
                    let source = CLLocationCoordinate2D.init(latitude: slang ?? 0.0, longitude: slong ?? 0.0)
                    
                    let dlang = Double(self.request.destination_latitude)
                    let dlong = Double(self.request.destination_longitude)
                  
                    let destination = CLLocationCoordinate2D.init(latitude: dlang ?? 0.0, longitude: dlong ?? 0.0)
                    self.fetchRoute(from:  source, to: destination)
                    
                    self.addMarker(lat: dlang ?? 0.0, long: dlong ?? 0.0, address: self.request.origin_address)
                    self.addMarker(lat: slang ?? 0.0, long: slong ?? 0.0, address: self.request.origin_address)
                    
                    
                    
                    if typeStr == "request_ride"{
                        self.scrollView.isHidden = false
                        self.viewButton.isHidden = false
                        
                    }else if typeStr == "current_ride"{
                        self.viewStartRide.isHidden = false
                        self.viewdirection.isHidden = false
                        self.rideID = self.request.ride_id
                        if self.request.is_verified  == "1" {
                             self.viewStartRide.isHidden = true
                             self.viewdirection.isHidden = false
                             self.viewEndRide.isHidden = false
                            if self.request.is_verified == "1"{
                               if self.request.is_ride  == "1"{
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CollectCashViewController") as! CollectCashViewController
                                    vc.reuest = self.request
                                self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        }
                    }
                    
                }else{
                    self.noCurrentTask.isHidden = false
                    self.scrollView.isHidden = true
                    self.viewButton.isHidden = true
                }
            }
          
        })
    }
    func cancelRequest(requestID:String){
        
        let dict = ["customer_id":self.request.customer_id] as? [String:Any]
        self.socket.emit("reject request",dict!)
        HomeHandler.manager.CancelRequest(requestID: requestID, completion: {_,_,_ in
           
        })
    }
    func acceptRequest(requestID:String){
        HomeHandler.manager.acceptRequest(requestID: requestID, completion: {result,success,message in
            DispatchQueue.main.async {
                if success == true{
                    self.viewdirection.isHidden = false
                    self.request.getData(dict: result)
                    self.viewStartRide.isHidden = false
                    self.rideID = self.request.ride_id
                    let data = self.request.emit_data as? [String:Any]
                    self.socket.emit("accept request",data!)
                }
            }
          
            })
    }
    
    func verifyOTP(){
        self.view.endEditing(true)
        HomeHandler.manager.VerifyOTPHandler(ride_id: rideID, temp_otp: txtOTP.text!, completion: {success,message in
            DispatchQueue.main.async {
                if success == true {
                    self.viewOtp.isHidden =  true
                    self.viewEndRide.isHidden = false
                    //
                    let dict = ["customer_id":self.request.customer_id] as? [String:Any]
                    self.socket.emit("start ride",dict!)
                }else{
                    Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: message)
                }
            }
        })
    }
    func cancelRide(ride_id:String,reason:String){
        let dict = ["customer_id":self.request.customer_id] as? [String:Any]
        self.socket.emit("driver cancel ride",dict!)
        HomeHandler.manager.CancelRideHandler(ride_id: ride_id, cancel_reason: reason, completion: {_,_ in
          })
    }
    
    func endRide(requestID:String){
        HomeHandler.manager.endRideHandler(requestID: rideID, completion: {scuccess,_,message in
            DispatchQueue.main.async {
                if scuccess == true {
                    self.viewdirection.isHidden = true
                    let dict = ["customer_id":self.request.customer_id] as? [String:Any]
                    self.socket.emit("end ride",dict!)
                    self.viewEndRide.isHidden = true
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CollectCashViewController") as! CollectCashViewController
                    vc.socket = self.socket
                    vc.reuest = self.request
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.viewEndRide.isHidden = false
                    
                    Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: message)
                }
                
            }
           
        })
    }
  
    
    func playAudioFile() {
        guard let url = Bundle.main.url(forResource: "alert", withExtension: "mp3") else { return }
        
        do {
            
            try AVAudioSession.sharedInstance().setActive(true)
            
            objPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let aPlayer = objPlayer else { return }
            aPlayer.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        
        let session = URLSession.shared
        
        //self.view = mapView
        
        
        
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=AIzaSyA6Cj_d5gtJFaTkwBGKQlGk5th2GzYwr4I")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any], let jsonResponse = jsonResult else {
                print("error in JSONSerialization")
                return
            }
            
            guard let routes = jsonResponse["routes"] as? [Any] else {
                return
            }
            if routes.count == 0  {
                return
            }
            guard let route = routes[0] as? [String: Any] else {
                return
            }
            
            guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                return
            }
            
            guard let polyLineString = overview_polyline["points"] as? String else {
                return
            }
            
            //Call this method to draw path on map
            self.drawPath(from: polyLineString)
        })
        task.resume()
    }
    func drawPath(from polyStr: String){
        DispatchQueue.main.async {
            let path = GMSPath(fromEncodedPath: polyStr)
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 3.0
            polyline.map = self.viewMap
            if self.viewMap != nil
            {
                let bounds = GMSCoordinateBounds(path: path!)
                self.viewMap!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
            }
        }
    
    }
    func addMarker(lat:Double,long:Double,address:String){
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, long)
        marker.title = address
        marker.snippet = ""
        marker.map = self.viewMap
       
    }
}
