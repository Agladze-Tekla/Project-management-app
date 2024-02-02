//
//  UnderlinedTextField.swift
//  TaskManagmentApp
//
//  Created by Tekla on 2/1/24.
//

import UIKit

final class UnderlinedTextField: UITextField {
    let underlineLayer = CALayer()
    
    func setupUnderlineLayer() {
        var frame = self.bounds
        frame.origin.y = frame.size.height - 1
        frame.size.height = 1
        underlineLayer.frame = frame
        underlineLayer.backgroundColor = UIColor.systemGray.cgColor
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.addSublayer(underlineLayer)
    }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(underlineLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUnderlineLayer()
    }
}
