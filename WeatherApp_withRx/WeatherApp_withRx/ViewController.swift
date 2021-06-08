//
//  ViewController.swift
//  WeatherApp_withRx
//
//  Created by 최강훈 on 2021/06/08.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController {
    
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cityNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map { self.cityNameTextField.text }
            .subscribe(onNext: { city in
                if let city = city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.fetchWeather(by: city)
                    }
                }
            }).disposed(by: disposeBag)
        
    }
    
    private func fetchWeather(by city: String) {
        
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL.urlForWeatherAPI(city: cityEncoded)
        else { return }
        
        let resource = Resource<WeatherResult>(url: url)
        
        let search = URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: WeatherResult.empty)
        
        search.map { "\($0.main.temp) ℃" }
            .drive(self.temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        
        search.map { "\($0.main.humidity) 💦"}
            .drive(self.humidityLabel.rx.text)
            .disposed(by: disposeBag)
        
//        search.map { "\($0.main.temp) ℃" }
//            .bind(to: self.temperatureLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        search.map { "\($0.main.humidity) 💦"}
//            .bind(to: self.humidityLabel.rx.text)
//            .disposed(by: disposeBag)
    }
    
    private func displayWeather(_ weather: Weather?) {
        
        if let weather = weather {
            self.temperatureLabel.text = "\(weather.temp) ℃"
            self.humidityLabel.text = "\(weather.humidity) 💦"
        } else {
            self.temperatureLabel.text = "none"
            self.humidityLabel.text = "﹖"
        }
        
    }


}

