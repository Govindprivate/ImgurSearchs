//
//  BaseViewController.swift
//  ImgurSearchs
//
//  Created by Govind Kumar on 15/06/23.
//

import UIKit

class BaseViewController: UIViewController {
    
    //MARK: Variable
    var activityView: UIActivityIndicatorView?
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Show activity indicator where BaseViewController is use
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }
    
    //Hide activity indicator
    func hideActivityIndicator(){
        if (activityView != nil){
            activityView?.stopAnimating()
        }
    }
    
    //Show Alert where BaseViewController is use
    func showAlert(title: String?, message: String?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let alert = UIAlertController(title: title ?? "", message: message ?? "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
