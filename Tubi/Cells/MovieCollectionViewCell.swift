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
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .gray
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp_top)
            make.width.equalTo(contentView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(contentView)
            make.top.equalTo(imageView.snp_bottom).offset(5)
            make.bottom.equalTo(contentView.snp_bottom)
        }
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(movieItem: MovieSearchItem) {
        if let imageUrl = movieItem.imageUrl {
            imageView.setImage(from: imageUrl)
        }
        titleLabel.text = movieItem.title
    }
}
