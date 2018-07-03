//
//  CVViewController.swift
//  Stretchy
//
//  Created by Ju on 2018/7/2.
//  Copyright © 2018年 Ju. All rights reserved.
//

import UIKit

class CVViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 70)
        
        view.backgroundColor = UIColor.cyan
        
        collectionView.dataSource = self

        let header = Bundle.main.loadNibNamed("TabsHeaderView", owner: nil, options: nil)?.first as! TabsHeaderView
        collectionView.addSubview(header)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if let tagView = cell.viewWithTag(100),
            let label = tagView as? UILabel {
            label.text = String(indexPath.item)
        }
        return cell
    }
    

}
