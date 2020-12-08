//
//  StudentListViewModel.swift
//  MVVMDemo
//
//  Created by Sagar Kalathil on 24/09/20.
//  Copyright © 2020 Sagar Kalathil. All rights reserved.
//

import Foundation
class StudentListViewModel: NSObject {
    
    private var apiService: WebServiceManager!
    //Computed Properties
    private(set) var arrStudentData = [Student]() {
        didSet {
        self.bindStudentViewModelToController()
        }
    }
    var strUrl = String()
    var bindStudentViewModelToController : (() -> ()) = {}
    override init() {
        super.init()
        self.apiService = WebServiceManager()
        self.callStudentListApi()
    }
    
    
    func callStudentListApi() {
        strUrl = "https://jsonplaceholder.typicode.com/posts"
        self.apiService.callGetApi(strUrl: strUrl) { (arr, isSuccess) in
            do{
                let decoder = JSONDecoder()
                let arrStudents = try decoder.decode([Student].self, from: arr!)
                self.arrStudentData = arrStudents
            }
            catch {
                print("json error: \(error)")
            }
        }
    }
}
