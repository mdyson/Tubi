//
//  MovieCollectionViewCell.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/25/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import SnapKit
import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp_top)
            make.width.equalTo(contentView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(contentView)
            make.top.equalTo(imageView.snp_bottom).offset(5)
            make.bottom.equalTo(contentView.snp_bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(movieItem: MovieItem) {
        if let imageUrl = movieItem.imageUrl {
            imageView.setImage(from: imageUrl)
        }
        titleLabel.text = movieItem.title
    }
}
