//
//  ViewController.swift
//  TapcartWeather
//
//  Created by Justin Hall on 1/30/19.
//  Copyright © 2019 jhall. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    
    let viewModel = WeatherViewModel(apiClient: APIClient())
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: screenWidth/3, height: 2*(screenWidth/3))
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textField.becomeFirstResponder()
        initilaHidingItems()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.register(UINib(nibName: WeatherCell.id, bundle: nil), forCellWithReuseIdentifier: WeatherCell.id)
    }
    
    func initilaHidingItems() {
        _ = [weatherIcon, locationLabel, weatherConditionLabel, collectionView, currentTempLabel].map {
            return $0?.isHidden = true
        }
    }
    
    @IBAction func searchStart(_ sender: Any) {
        textField.resignFirstResponder()
        collectionView.isHidden = false
        let query = textField.text ?? ""
        viewModel.getWeather(query: query) { [weak self](weather) in
            mainQueue {
                if let weather = weather {
                 self?.configureWeatherView(weather)
                }
            }
        }
        
        viewModel.fetchForecasts(query: query) { [weak self](forecasts: [Forecast]) in
            mainQueue{
                if forecasts.isEmpty {
                    self?.showAlert(weatherService: "forecasts")
                } else {
                    self?.collectionView.isHidden = false
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    private func configureWeatherView(_ weather: Weather) {
        
        locationLabel.text = weather.location
        
        weatherIcon.image = UIImage(named: weather.imageName)
        let templateImage = weatherIcon.image?.withRenderingMode(.alwaysTemplate)
        weatherIcon.image = templateImage
        weatherIcon.tintColor = UIColor(named: "themeGreen")
        
        weatherConditionLabel.text = weather.imageName
        self.currentTempLabel.text = "\(weather.temp.formatAsCDegree)"
           
        headerView.backgroundColor = weather.headerColor ?? UIColor.systemPink
    _ = [weatherIcon, locationLabel, weatherConditionLabel, currentTempLabel].map {
            return $0?.isHidden = false
        }
    }
    
    private func showAlert(weatherService: String) {
        let alertController = UIAlertController(title: "Oops", message: "\(weatherService) Not availabel", preferredStyle: .alert)
        let action = UIAlertAction(title: "Cool", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.forecasts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCell.id, for: indexPath) as? WeatherCell {
            cell.updateCell(forecast: viewModel.forecasts[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}
