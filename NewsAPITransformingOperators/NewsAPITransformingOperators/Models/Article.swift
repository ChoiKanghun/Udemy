//
//  Article.swift
//  NewsAPITransformingOperators
//
//  Created by 최강훈 on 2021/06/07.
//

import Foundation

struct ArticlesList: Decodable {
    let articles: [Article]?
    
}

extension ArticlesList {
    static var all: Resource<ArticlesList> = {
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=e9b514c39c5f456db8ed4ecb693b0040")!
        return Resource(url: url)
    }()
}

struct Article: Decodable {
    let title: String?
    let description: String?
}


