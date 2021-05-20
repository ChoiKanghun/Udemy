//
//  ViewController.swift
//  CameraFilterRxSwift
//
//  Created by 최강훈 on 2021/05/18.
//

import UIKit
import RxSwift


class ViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var applyFilterButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextViewController = segue.destination as? UINavigationController,
              let photosCollectionViewController = nextViewController.viewControllers.first as? PhotosCollectionViewController
        else { fatalError("segue destination is not found")}
        
        photosCollectionViewController.selectedPhot
            .subscribe(onNext: { [weak self] photo in
                DispatchQueue.main.async {
                    self?.updateUI(with: photo)
                }
            }).disposed(by: disposeBag)
    }

    private func updateUI(with photo: UIImage) {
        self.photoImageView.image = photo
        self.applyFilterButton.isHidden = false
    }
    @IBAction func touchUpApplyFilterButton(_ sender: Any) {
        guard let sourceImage = self.photoImageView.image
        else {
            print ("can't get source Image")
            return
        }
        
        FilterService().applyFilter(to: sourceImage)
            .subscribe(onNext: { (filteredImage) in
                DispatchQueue.main.async {
                    self.photoImageView.image = filteredImage
                }
            }).disposed(by: disposeBag)
        
    }
}

