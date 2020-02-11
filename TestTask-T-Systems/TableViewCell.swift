//
//  TableViewCell.swift
//  TestTask-T-Systems
//
//  Created by Andrei Konovalov on 10.02.2020.
//  Copyright © 2020 Andrei Konovalov. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell{
  @IBOutlet weak var mainImage: UIImageView?
  @IBOutlet weak var filmName: UILabel?
  @IBOutlet weak var date: UILabel?
  @IBOutlet weak var filmDescription: UILabel?
  @IBOutlet weak var calendar:UIButton?
  @IBOutlet weak var rateView:UIView!
  @IBOutlet weak var scoreLable:UILabel?{
    didSet{
      drawRateView()
    }
  }
  let la = CAShapeLayer()
  var imageURL:URL?
  
  private func drawRateView(){
    calendar?.layer.cornerRadius = 15
    rateView?.layer.cornerRadius = (rateView?.frame.width ?? 15)/2
    rateView?.layer.backgroundColor = CGColor(#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1))

    la.path = UIBezierPath(roundedRect: CGRect(x: 64, y: 64, width: 160, height: 160), cornerRadius: 50).cgPath
    la.fillColor = UIColor.red.cgColor
    la.masksToBounds = true
    rateView?.layer.addSublayer(la)
  }
 

}
