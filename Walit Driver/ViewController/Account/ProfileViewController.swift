//
//  ProfileViewController.swift
//  Walit Driver
//
//  Created by Arjun on 3/3/19.
//  Copyright © 2019 Window. All rights reserved.
//

import UIKit
import AlamofireImage
class ProfileViewController: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMobileNumer: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblCounty: UILabel!
    
    @IBOutlet weak var lblVehicle: UILabel!
    
    
    
    var result = NSDictionary()
    
    var arrItem = ["Vehicle Model","Registration Number","Licence Number","Insurance Expire Date","Permit Number"]
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblUserName.text = Global.sharedInstance.user.first_name
        self.lblMobileNumer.text = Global.sharedInstance.user.phone
        self.lblEmail.text = Global.sharedInstance.user.email
       
        let strImage = Global.sharedInstance.user.image
        
        let myURL = strImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        if let url = URL(string: myURL!) {
            self.imgUser.af_setImage(withURL: url)
        }
        else{
            self.imgUser.image = #imageLiteral(resourceName: "uploadUser")
        }
        ProfileHandler.manager.getProfileDetail(completion: {
            result,success,error in
             print(result)
            DispatchQueue.main.async {
                 self.result = result
                 self.tableView.reloadData()
               
                if  let courrnecy =  result.value(forKey: "country_name") as? String{
                   if let country_name = result.value(forKey: "country_name") as? String{
                        self.lblCounty.text = country_name + courrnecy
                    }
                    
                }
                if  let taxi_owner =  result.value(forKey: "country_name") as? String{
                    self.lblVehicle.text = "Taxi Owner: " + taxi_owner
                    
                }
                
                
            }
           
        })
    }
    
    override func viewDidLayoutSubviews() {
        self.addGradientWithColor()
        self.imgUser.layer.cornerRadius = self.imgUser.frame.height / 2
        self.imgUser.clipsToBounds = true
    }
    
   
    
    
    @IBAction func imagePickerBtnAction(selectedButton: UIButton)
    {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            self.imgUser.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            self.imgUser.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        }
        self.uploadImage()
    }
    func uploadImage(){
        ChanagePasswordHandler.manager.uploadImage(image: imgUser.image!, completion: {success,message in
            if success == true{
                Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Success", alertMessage: "Image uplaod sucessfully.")
            }else{
                Miscellaneous.APPDELEGATE.showAlertFor(alertTitle: "Error", alertMessage: message)
            }
            
        })
    }
}
extension ProfileViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if result.count != 0 {
            return arrItem.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        cell.lblTitle.text = arrItem[indexPath.row]
        cell.lblDate.text = ""
        if indexPath.row == 0{
            
            cell.lblSubTitle.text = result.value(forKey: "vehicle_model") as? String
            let strImage = result.value(forKey: "vehicle_image") as? String
            
            let myURL = strImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if let url = URL(string: myURL!) {
                cell.img.af_setImage(withURL: url)
            }
            else{
                 cell.img.image = #imageLiteral(resourceName: "uploadUser")
            }
            
        }else if indexPath.row == 1{
            cell.lblSubTitle.text = arrItem[indexPath.row]
            cell.lblSubTitle.text = result.value(forKey: "vehicle_registration_no") as? String
        
            let strImage = result.value(forKey: "vehicle_registration_img") as? String
            
            let myURL = strImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if let url = URL(string: myURL!) {
                cell.img.af_setImage(withURL: url)
            }
            else{
                cell.img.image = #imageLiteral(resourceName: "uploadUser")
            }
        }else if indexPath.row == 2{
            cell.lblSubTitle.text = arrItem[indexPath.row]
            cell.lblSubTitle.text = result.value(forKey: "driving_licence_no") as? String
            
            let strImage = result.value(forKey: "driving_licence_img") as? String
            
            let myURL = strImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if let url = URL(string: myURL!) {
                cell.img.af_setImage(withURL: url)
            }
            else{
                cell.img.image = #imageLiteral(resourceName: "uploadUser")
            }
        }else if indexPath.row == 3{
            cell.lblSubTitle.text = arrItem[indexPath.row]
            cell.lblSubTitle.text = result.value(forKey: "vehicle_insurance_expire_date") as? String
            
            
            let strImage = result.value(forKey: "vehicle_insurance_img") as? String
            
            let myURL = strImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if let url = URL(string: myURL!) {
                cell.img.af_setImage(withURL: url)
            }
            else{
                cell.img.image = #imageLiteral(resourceName: "uploadUser")
            }
        }else if indexPath.row == 4{
            cell.lblSubTitle.text = arrItem[indexPath.row]
            cell.lblSubTitle.text = result.value(forKey: "vehicle_permit") as? String
            if let date = result.value(forKey: "vehicle_permit_date") as? String{
               cell.lblDate.text = "Permit Date: \(date)"
            }
           
            let strImage = result.value(forKey: "vehicle_permit_image") as? String
            
            let myURL = strImage?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            if let url = URL(string: myURL!) {
                cell.img.af_setImage(withURL: url)
            }
            else{
                cell.img.image = #imageLiteral(resourceName: "uploadUser")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewViewController")as! ImageViewViewController
        if indexPath.row == 0 {
            vc.imageview = result.value(forKey: "vehicle_image") as? String ?? ""
        }else if indexPath.row == 1 {
            vc.imageview = result.value(forKey: "vehicle_registration_img") as? String ?? ""
        }else if indexPath.row == 2 {
            vc.imageview = result.value(forKey: "driving_licence_img") as? String ?? ""
        }else if indexPath.row == 3 {
            vc.imageview = result.value(forKey: "vehicle_insurance_img") as? String ?? ""
        }else if indexPath.row == 4 {
            vc.imageview = result.value(forKey: "vehicle_permit_image") as? String ?? ""
        }
        
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
