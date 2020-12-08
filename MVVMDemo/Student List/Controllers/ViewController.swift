//
//  ViewController.swift
//  MVVMDemo
//
//  Created by Sagar Kalathil on 24/09/20.
//  Copyright © 2020 Sagar Kalathil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var studentTblView: UITableView!
    private var studentViewModel:StudentListViewModel!
    private var dataSource : StudentListDataSource<studentListCell,Student>!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.callViewModelForUpdate()
    }

    func callViewModelForUpdate() {
        self.studentViewModel = StudentListViewModel()
        self.studentViewModel.bindStudentViewModelToController = {
            self.updateDataSource()
        }
    }
    
    func updateDataSource() {
        self.dataSource = StudentListDataSource(cellIdentifier: "studentListCell", items: self.studentViewModel?.arrStudentData ?? [Student](), configureCell: { (cell, student) in
            cell.lblName.text = student.title ?? ""
            cell.lblDetails.text = student.body ?? ""
            
        })
        DispatchQueue.main.async {
            self.studentTblView.dataSource = self.dataSource
            self.studentTblView.reloadData()
        }
    }
}



