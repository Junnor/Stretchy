//
//  MutiViewController.swift
//  Stretchy
//
//  Created by Ju on 2018/7/3.
//  Copyright © 2018年 Ju. All rights reserved.
//

import UIKit

let num44: CGFloat = 44
let width = UIScreen.main.bounds.width
let height = UIScreen.main.bounds.height
let subHeight = height-num44

class MutiViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.showsVerticalScrollIndicator = false
        }
    }
    
    var subScrollView: UIScrollView!
    
    lazy var levelListView: YBLevelListView = {
        let model = YBLevelListConfigModel()
        model.titleArr = ["One", "two"]
        model.titleColorOfSelected = UIColor.red
        
        let listView = YBLevelListView(frame: CGRect(x: 0, y: 0, width: width, height: num44), configModel: model)!
        listView.backgroundColor = UIColor.white
        listView.delegate = self
        return listView
    }()
    
    lazy var picAndTextTableView: Sub1TableView = {
        let picAndTextTableView = Sub1TableView(frame: CGRect(x: 0, y: 0, width: width, height: subHeight), style: .plain)
        picAndTextTableView.backgroundColor = UIColor.white
        picAndTextTableView.mainVC = self
        return  picAndTextTableView
    }()
    
    lazy var evaluateTableView: Sub1TableView = {
        let evaluateTableView = Sub1TableView(frame: CGRect(x: width, y: 0, width: width, height: subHeight), style: .plain)
        evaluateTableView.backgroundColor = UIColor.white
        evaluateTableView.mainVC = self
        return evaluateTableView
    }()

    var offsetType: OffsetType = .min
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension MutiViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 400 : subHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "nullCell0")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "nullCell0")
            }
            cell?.backgroundColor = UIColor.cyan
            return cell!
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "nullCell1")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "nullCell1")
                
                subScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: subHeight))
                subScrollView.bounces = true
                subScrollView.contentSize = CGSize(width: width*2, height: subHeight)
                subScrollView.isPagingEnabled = true
                subScrollView.showsHorizontalScrollIndicator = false
                subScrollView.delegate = self
                cell?.addSubview(subScrollView)
                
                subScrollView.addSubview(picAndTextTableView)
                
                subScrollView.addSubview(evaluateTableView)

                cell?.selectionStyle = .none
            }
            return cell!
        }
    }
    



    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return levelListView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? num44 : 0
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == subScrollView {
            self.evaluateTableView.isScrollEnabled = false
            self.picAndTextTableView.isScrollEnabled = false
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == subScrollView {
            self.evaluateTableView.isScrollEnabled = true
            self.picAndTextTableView.isScrollEnabled = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            if (scrollView.contentOffset.y >= (scrollView.contentSize.height-scrollView.frame.size.height-0.5)) {
                self.offsetType = .max;
            } else if (scrollView.contentOffset.y <= 0) {
                self.offsetType = .min;
            } else {
                self.offsetType = .center;
            }
            
            if (self.levelListView.selectedIndex == 0 && picAndTextTableView.offsetType == .center) {
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentSize.height-scrollView.frame.size.height)
            }
            
            if (self.levelListView.selectedIndex == 1 && evaluateTableView.offsetType == .center) {
                
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentSize.height-scrollView.frame.size.height)
            }
        } else if scrollView == subScrollView {
            levelListView.configAnimationOffsetX(subScrollView.contentOffset.x)
        }
    }
    
}

extension MutiViewController: YBLevelListViewDelegate {
    func yBLevelListView(_ yBLevelListView: YBLevelListView!, choose index: Int) {
        subScrollView.setContentOffset(CGPoint(x: width*CGFloat(index), y: 0), animated: false)
    }
}
