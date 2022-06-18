//
//  ImageCropViewController.swift
//  ExampleProj
//
//  Created by 梁光辉 on 2022/2/16.
//

import UIKit
import LoveUIKit

final class ImageCropViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupSegment()
        DispatchQueue.main.async {
            self.setImages()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private lazy var segmentControl = UISegmentedControl().then { seg in
        seg.apportionsSegmentWidthsByContent = true
    }
    
    var image = UIImage(named: "purple_sport")
//    var image = UIImage(named: "purple_sport_flipped")
    
    let imageView = UIImageView()   // 显示原始图片比例
    
    let imageView1 = UIImageView()  // 高大于宽
    let imageView2 = UIImageView()  // 宽大于高
    
    private let cropMode: [Int: String] = [0: "上",
                                           1: "左",
                                           2: "下",
                                           3: "右",
                                           4: "左上",
                                           5: "右上",
                                           6: "左下",
                                           7: "右下",
                                           8: "中心"]

    private func setupViews() {
        view.backgroundColor = .cyan
        view.addSubview(imageView)
        view.addSubview(imageView1)
        view.addSubview(imageView2)
        
        imageView.image = image
        imageView.snp.makeConstraints { make in
            make.width.equalTo(110 * 3)
            make.height.equalTo(30 * 3)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
        
        imageView1.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(200)
            make.top.equalTo(imageView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        imageView1.backgroundColor = .yellow
        
        imageView2.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(300)
            make.top.equalTo(imageView1.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        imageView2.backgroundColor = .magenta
    }
    
    private func setImages() {
        imageView1.image = image?.gh_scaleAspectCrop(forSize: CGSize(width: imageView1.frame.width, height: imageView1.frame.height), withMode: .init(rawValue: 0) ?? .top)
        imageView2.image = image?.gh_scaleAspectCrop(forSize: CGSize(width: imageView2.frame.size.width, height: imageView2.frame.size.height), withMode: .init(rawValue: 0) ?? .top)
    }
    
    private func setupSegment() {
        view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints { make in
            make.bottom.equalTo(-200)
            make.left.greaterThanOrEqualToSuperview()
            make.right.greaterThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
        }
        for index in 0...8 {
            segmentControl.insertSegment(withTitle: cropMode[index], at: index, animated: false)
        }
        segmentControl.addTarget(self, action: #selector(selected(_:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
    }
    
    @objc func selected(_ sender: UISegmentedControl) {
        imageView1.image = image?.gh_scaleAspectCrop(forSize: CGSize(width: imageView1.frame.width, height: imageView1.frame.height), withMode: .init(rawValue: sender.selectedSegmentIndex) ?? .top)
        imageView2.image = image?.gh_scaleAspectCrop(forSize: CGSize(width: imageView2.frame.size.width, height: imageView2.frame.size.height), withMode: .init(rawValue: sender.selectedSegmentIndex) ?? .top)
    }
}
