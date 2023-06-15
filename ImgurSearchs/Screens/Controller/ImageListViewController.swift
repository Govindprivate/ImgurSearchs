//
//  ImageListViewController.swift
//  ImgurSearchs
//
//  Created by Govind Kumar on 15/06/23.
//

import UIKit

class ImageListViewController: BaseViewController {
    
    //MARK: Outlets
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var toggleViewButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    
    //MARK: Variable's
    var isListView = true
    var isAPICalling = false
    var imageDataArray: [ImageData] = []
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        searchTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchTextField.becomeFirstResponder()
    }
    
    
    //MARK: Button Action
    @IBAction func toggleButtonClicked(_ sender: Any) {
        if self.imageDataArray.count > 0 {
            toggleViewButton.setTitle(isListView ? Constant.Header.list : Constant.Header.grid, for: .normal)
            isListView = !isListView
            
            self.imageCollectionView.setContentOffset(CGPoint(x:0,y:0), animated: true)
            self.imageCollectionView.reloadData()
        }
    }
}

extension ImageListViewController{
    
    //MARK: API Call to get image data
    func callSearchImageAPI(text:String){
        self.showActivityIndicator()
        self.isAPICalling = true
        self.imageCollectionView.reloadData()
        
        APIManager.getImagesForSearch(text: text).responseDecodable(of: ImageDataModel.self) { response in
            self.hideActivityIndicator()
            self.isAPICalling = false
            self.imageDataArray = []
            if let dataArray = response.value?.data{
                for data in dataArray{
                    let isImage = (data.images?.first?.type ?? "").contains(Constant.Message.imageString)
                    if isImage{
                        self.imageDataArray.append(data)
                    }
                }
            }
            self.imageCollectionView.reloadData()
        }
    }
    
    //on click of search button we trigger callback fucntion which then allow us to get image for user entered query
    //store same string in user preference
    func triggerCallback(){
        searchTextField.resignFirstResponder()
        let text = searchTextField.text ?? ""
        if text == ""{
            self.showAlert(title: Constant.Message.pleaseEnterTextToSearch, message: "")
            return
        }
        self.getImageDataFor(text: text)
    }
    
    //MARK: API Call to get image data
    func getImageDataFor(text:String){
        self.imageDataArray = []
        self.imageCollectionView.reloadData()
        
        if !Reachability.isConnectedToNetwork(){
            self.showAlert(title: Constant.Message.noInternetConnectionTitle, message: Constant.Message.noInternetConnectionMessage)
            return
        }
        callSearchImageAPI(text:text)
    }
}

//MARK: Textfield delegate
extension ImageListViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        triggerCallback()
        return false
    }
}

//MARK: CollectionView Datasource and Delegate
extension ImageListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.imageDataArray.count == 0 {
            //check if calling api, if api call in progress showing message as "Fetching Data"
            //check for connectivity if user not connected to inter showing error message "No Internet Connection \nMake sure your device is connected to the internet."
            //check if there are any images available for user search query if no image available showing message as "No data found"
            collectionView.setEmptyMessage(isAPICalling ? Constant.Message.fetchingData : !Reachability.isConnectedToNetwork() ? Constant.Message.noInternetConnectionTitleAndMessage : Constant.Message.NoDataFound)
        } else {
            collectionView.restore()
        }
        return imageDataArray.count
    }
    
    // using variable isListView we identity if user has selected for which view
    //if isListView == true then using cell as "ImageCellList"
    //if isListView == false then using cell as "ImageCellGrid"
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let imageData = imageDataArray[indexPath.row]
        if isListView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.Identifier.imageCellList, for: indexPath) as! ImageCell
            cell.roundCorners(16)
            return getImageCell(cell: cell, imageData:imageData)
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.Identifier.imageCellGrid, for: indexPath) as! ImageCell
            cell.roundCorners(8)
            return getImageCell(cell: cell, imageData:imageData)
        }
    }
    
    //function to set all data to cell and ui formating
    func getImageCell(cell: ImageCell, imageData:ImageData) -> ImageCell{
        cell.countLabel.roundCorners(8)
        cell.countLabel.isHidden = true
        
        let url = imageData.images?.first?.link ?? ""
        cell.imageView.setImage(url: url)
        cell.titleLabel.text = imageData.title ?? ""
        if let count = imageData.imagesCount {
            cell.countLabel.isHidden = count <= 1
            cell.countLabel.text = "1 / \(imageData.imagesCount ?? 0)"
        }
        cell.dateLabel.text = (imageData.dateTime ?? 0).getDateStringFromUnixTime()
        return cell
    }
    
    // using variable isListView we identity if user has selected for which view
    //if isListView == true then using cgsize as (width: (collectionView.frame.size.width), height: 200)"
    //if isListView == false then using cgsize as (width: (collectionView.frame.size.width/2 - 4), height: 250)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isListView{
            return CGSize(width: (collectionView.frame.size.width), height: 180)
        }else{
            return CGSize(width: (collectionView.frame.size.width/3 - 4), height: 200)
        }
    }
}
