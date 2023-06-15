//
//  Constant.swift
//  ImgurSearchs
//
//  Created by Govind Kumar on 15/06/23.
//

import Foundation

struct Constant{
    
    struct Header{
        static let grid = "Grid"
        static let list = "List"
        static let searchText = "Search imgur"
    }
    
    struct Message{
        static let noInternetConnectionTitle = "No Internet Connection"
        static let noInternetConnectionMessage = "Make sure your device is connected to the internet."
        static let pleaseEnterTextToSearch = "Please enter text to search"
        static let noInternetConnectionTitleAndMessage = "No Internet Connection \nMake sure your device is connected to the internet."
        static let fetchingData = "Fetching data"
        static let NoDataFound = "No data found"
        static let imageString = "image"
        static let noneString = "None"
    }
    
    struct Identifier{
        static let imageCellList = "ImageCellList"
        static let imageCellGrid = "ImageCellGrid"
    }
    
    struct DateFormate{
        static let dayMonthYearTime12Hours = "dd/MM/yy HH:mm:a"
    }
}
