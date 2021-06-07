//
//  NewsTableViewController.swift
//  NewsAPITransformingOperators
//
//  Created by 최강훈 on 2021/06/07.
//

import UIKit
import RxSwift
import RxCocoa

class NewsTableViewController: UITableViewController {

    let disposeBag = DisposeBag()
    
    private var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        populateNews()
    }
    
    private func populateNews() {
        
//        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=e9b514c39c5f456db8ed4ecb693b0040")
//        else {return}
//      let resource = Resource<ArticlesList>(url: url)
        
        
        URLRequest.load(resource: ArticlesList.all)
            .subscribe(onNext:  { [weak self] result in
                if let result = result,
                   let articles = result.articles {
                    self?.articles = articles
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }).disposed(by: disposeBag)
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "articleTableViewCell") as? ArticleTableViewCell
        else {fatalError("no articletableviewcell")}
        
        cell.titleLabel.text = self.articles[indexPath.row].title
        cell.descriptionLabel.text = self.articles[indexPath.row].description
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // api-key: e9b514c39c5f456db8ed4ecb693b0040
    // api-GET: https://newsapi.org/v2/top-headlines?country=us&apiKey=e9b514c39c5f456db8ed4ecb693b0040

}
