//
//  Constant.swift
//  fBDemo
//
//  Created by Parvez Shaikh on 28/02/19.
//  Copyright © 2019 Parvez Shaikh. All rights reserved.
//

import Foundation

//"http://182.73.184.62:443/api/"
var GVBaseURL = "http://182.73.184.62:443/api/"
var GVImageBaseURL = "http://182.73.184.62:443"

var resturantId = 0
var catagoryId = 0
var countofCart = 0

var resturantIdTest = 0
//var arrCardItem = [String:AnyObject]() //Array of dictionary
var arrCardItem:Array<Any> = []
var dictTest = Dictionary<String, Array<Any>>()



let apirestaurantList = GVBaseURL + "restaurant/list"
let urlCatagorylink = "http://182.73.184.62:443/api/restaurantmenu/selectbyid/\(resturantId)/\(catagoryId)"

