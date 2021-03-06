//
//  Sub1TableView.swift
//  Stretchy
//
//  Created by Ju on 2018/7/3.
//  Copyright © 2018年 Ju. All rights reserved.
//

import UIKit

class Sub1TableView: UITableView, UIGestureRecognizerDelegate, ScrollOffSetProtocol {

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        dataSource = self
        delegate = self
        alwaysBounceVertical = true
        rowHeight = 100
    }
    
    var isFirstItem = true
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var mainVC: MutiViewController?
    
    var offsetType: OffsetType = .min  {
        didSet {
            if isFirstItem {
                if offsetType == .min {
                    mainVC?.secondItemTableView.offsetType = .min
                    mainVC?.secondItemTableView.setContentOffset(.zero, animated: false)
                }
//                print("isFirstItem offsetType = \(offsetType)")
            } else {
                if offsetType == .min {
                    mainVC?.firstItemTableView.offsetType = .min
                    mainVC?.firstItemTableView.setContentOffset(.zero, animated: false)
                }
//                print("not isFirstItem offsetType = \(offsetType)")
            }
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}

extension Sub1TableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "simpleCell")
        }
        cell?.textLabel?.text = isFirstItem ? "Hello \(indexPath.item)" : "World \(indexPath.item)"
        
        return cell!
    }
}

extension Sub1TableView: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let type = self.mainVC!.offsetType
        
        if (scrollView.contentOffset.y <= 0) {
            self.offsetType = .min
        } else {
            self.offsetType = .center;
        }
        
        if (type == .min) {
            scrollView.contentOffset = .zero;
        }
        if (type == .center) {
            scrollView.contentOffset = .zero;
        }

    }
    
}
