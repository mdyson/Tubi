//
//  MovieDetailViewController.swift
//  Tubi
//
//  Created by Matthew Dyson on 3/25/19.
//  Copyright © 2019 Matthew Dyson. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MovieDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private let loadingSpinner = UIActivityIndicatorView(style: .whiteLarge)
    private let imageView = UIImageView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()

    private let viewModel: MovieDetailViewModel

    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .purple
        addSubviews()
        makeConstraints()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.makeRequest()
    }

    func addSubviews() {
        view.addSubview(loadingSpinner)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
    }

    func makeConstraints() {
        loadingSpinner.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        imageView.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(imageView.snp_bottom).offset(10)
        }
    }

    func setupBindings() {
        viewModel.movieItem
            .map { $0?.imageUrl }
            .flatMap({ Observable.from(optional: $0) })
            .bind(to: imageView.rx.imageURL)
            .disposed(by: disposeBag)

        viewModel.movieItem
            .map({ $0?.title })
            .bind(to: titleLabel.rx.text )
            .disposed(by: disposeBag)

        viewModel.movieItem
            .map({ "Index: \($0?.index ?? -1)" })
            .bind(onNext: { self.title = $0 })
            .disposed(by: disposeBag)
    }
}
