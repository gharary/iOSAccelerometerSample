//
//  CollectionViewController.swift
//  AccelerometerSample
//
//  Created by Mohammad Gharari on 7/2/21.
//

import UIKit
import Combine
private let reuseIdentifier = "CollectionCell"

class CollectionViewController: UICollectionViewController {

    
    private var xValues:[Double] = []
    private var yValues:[Double] = []
    private var zValues:[Double] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()

        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name(rawValue: "AcceleroRefresh"), object: nil)
        
        AcceleroModel.sharedInstance.clearData()
        AcceleroManager.sharedInstance.startAccelero()
        
        self.collectionView.backgroundColor = .white
    }


    
    @objc func updateUI() {
         xValues = AcceleroModel.sharedInstance.calcStats(array: AcceleroModel.sharedInstance.xArrays)
         yValues = AcceleroModel.sharedInstance.calcStats(array: AcceleroModel.sharedInstance.yArrays)
         zValues = AcceleroModel.sharedInstance.calcStats(array: AcceleroModel.sharedInstance.zArrays)
        
        self.collectionView.reloadData()
        
    }
    
    func getTitle(indexPath:IndexPath) -> String {
        
        switch indexPath.row {
        case 0:
            return "Max: "
        case 1:
            return "Median: "
        case 2:
            return "Mean: "
        case 3:
            return "StDev: "
        case 4:
            return "Min: "
        case 5:
            return "Count: "
        case 6:
            return "ZeroCrossed: "
        default:
            return ""
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 7
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AcceleroViewCell
    
        
        // Configure the cell
    
        switch indexPath.section {
        case 0:
            cell.textLabel.text = "\(String(format:"%.5f",xValues.count > 0 ? xValues[indexPath.row] : 0))"
        case 1:
            cell.textLabel.text = "\(String(format:"%.5f",yValues.count > 0 ? yValues[indexPath.row] : 0))"
        case 2:
            cell.textLabel.text = "\(String(format:"%.5f",zValues.count > 0 ? zValues[indexPath.row] : 0))"
        default:
            break
        }
        
        cell.textTitle.text = getTitle(indexPath: indexPath)
        
        cell.backgroundColor = .green
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? HeaderCollectionReusableView {
            switch indexPath.section {
            case 0:
                sectionHeader.sectionHeader.text = "xAxis"
            case 1:
                sectionHeader.sectionHeader.text = "yAxis"
            case 2:
                sectionHeader.sectionHeader.text = "zAxis"
            default:
                sectionHeader.sectionHeader.text = "Section \(indexPath.section)"
            }
            
            sectionHeader.tintColor = .black
            sectionHeader.backgroundColor = .lightGray
            return sectionHeader
        }
        return UICollectionReusableView()
    }
}
extension CollectionViewController : UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let padding: CGFloat =  50
            let collectionViewSize = collectionView.frame.size.width - padding
            
            return CGSize(width: collectionViewSize/3, height: collectionViewSize/4)
        }

    
}
