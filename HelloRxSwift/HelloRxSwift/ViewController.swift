//
//  ViewController.swift
//  HelloRxSwift
//
//  Created by 최강훈 on 2021/05/17.
//

import UIKit
import RxSwift
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var mainWebView: WKWebView!
    @IBOutlet weak var subWebView: WKWebView!
    @IBOutlet weak var chatWebView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let mainUrl = URL(string: "https://42kchoi.tistory.com/")
        let subUrl = URL(string: "https://www.yna.co.kr/view/AKR20200302181000005")
        let chatUrl = URL(string: "https://m.blog.naver.com/ajdwk91/221766966286")
        
        let mainRequest = URLRequest(url: mainUrl!)
        let subRequest = URLRequest(url: subUrl!)
        let chatRequest = URLRequest(url: chatUrl!)
        
        mainWebView.load(mainRequest)
        subWebView.load(subRequest)
        chatWebView.load(chatRequest)
        
        print(1)
    }


}

