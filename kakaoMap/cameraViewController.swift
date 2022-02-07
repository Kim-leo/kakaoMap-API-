//
//  cameraViewController.swift
//  kakaoMap
//
//  Created by 김승현 on 2022/02/03.
//

import UIKit

class cameraViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var imageView: UIImageView!
    
    let imagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        

        
        
    }
    

  

}
