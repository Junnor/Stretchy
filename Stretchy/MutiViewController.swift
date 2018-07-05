//
//  MutiViewController.swift
//  Stretchy
//
//  Created by Ju on 2018/7/3.
//  Copyright © 2018年 Ju. All rights reserved.
//

import UIKit

let num44: CGFloat = 100
let width = UIScreen.main.bounds.width
let height = UIScreen.main.bounds.height
let subHeight = height-num44


enum OffsetType {
    case min
    case center
    case max
}


class MutiViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.showsVerticalScrollIndicator = false
        }
    }
    
    lazy var mainContainerScrollView: UIScrollView = {
        let sv = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: subHeight))
        sv.bounces = true
        sv.contentSize = CGSize(width: width*2, height: subHeight)
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.delegate = self
        return sv
    }()
    
    lazy var levelListView: YBLevelListView = {
        let model = YBLevelListConfigModel()
        model.titleArr = ["One", "two"]
        model.titleColorOfSelected = UIColor.red
        
        let listView = YBLevelListView(frame: CGRect(x: 0, y: 0, width: width, height: num44), configModel: model)!
        listView.backgroundColor = UIColor.white
        listView.delegate = self
        return listView
    }()
    
    lazy var firstItemTableView: Sub1TableView = {
        let firstItemV = Sub1TableView(frame: CGRect(x: 0, y: 0, width: width, height: subHeight), style: .plain)
        firstItemV.backgroundColor = UIColor.white
        firstItemV.isFirstItem = true
        firstItemV.mainVC = self
        return  firstItemV
    }()
    
    lazy var secondItemTableView: Sub1TableView = {
        let secondItemV = Sub1TableView(frame: CGRect(x: width, y: 0, width: width, height: subHeight), style: .plain)
        secondItemV.backgroundColor = UIColor.white
        secondItemV.isFirstItem = false
        secondItemV.mainVC = self
        return secondItemV
    }()

    var offsetType: OffsetType = .min {
        didSet {
//            print("muti offsetType = \(offsetType)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = Bundle.main.loadNibNamed("TabsHeaderView", owner: nil, options: nil)?.first as! TabsHeaderView
        tableView.addSubview(header)
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }

}

extension MutiViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return subHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "nullCell1")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "nullCell1")
            
            
            cell?.addSubview(mainContainerScrollView)
            
            mainContainerScrollView.addSubview(firstItemTableView)
            
            mainContainerScrollView.addSubview(secondItemTableView)
            
            cell?.selectionStyle = .none
        }
        return cell!
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == mainContainerScrollView {
            self.secondItemTableView.isScrollEnabled = false
            self.firstItemTableView.isScrollEnabled = false
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == mainContainerScrollView {
            self.secondItemTableView.isScrollEnabled = true
            self.firstItemTableView.isScrollEnabled = true
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
            
//            print("self.levelListView.selectedIndex = \(self.levelListView.selectedIndex)")
            
            if (self.levelListView.selectedIndex == 0 && firstItemTableView.offsetType == .center) {
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentSize.height-scrollView.frame.size.height)
            }
            
            if (self.levelListView.selectedIndex == 1 && secondItemTableView.offsetType == .center) {
                
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentSize.height-scrollView.frame.size.height)
            }
        } else if scrollView == mainContainerScrollView {
            levelListView.configAnimationOffsetX(mainContainerScrollView.contentOffset.x)
        }
    }
    
}

extension MutiViewController: YBLevelListViewDelegate {
    func yBLevelListView(_ yBLevelListView: YBLevelListView!, choose index: Int) {
        mainContainerScrollView.setContentOffset(CGPoint(x: width*CGFloat(index), y: 0), animated: false)
    }
}
