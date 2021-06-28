//
//  ViewController.swift
//  HwsP4
//
//  Created by Terry Kuo on 2021/6/27.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    
    //MARK: - Properties

    private var webView: WKWebView!
    private var progressView: UIProgressView!
    var urlString: String?
    
    private let websites = ["apple.com", "hackingwithswift.com"]
    
    lazy var openButton = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
    lazy var spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    lazy var refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
    lazy var progressButton = UIBarButtonItem(customView: progressView)
    
    
    //MARK: - App Lifecycle

    override func loadView() { //gets called before viewDidLoad
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        navigationItem.rightBarButtonItem =  openButton
        
        let url = URL(string: "https://" + urlString!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil) //!!!
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    //MARK: - Functional

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    @objc private func openTapped() {
        let ac = UIAlertController(title: "Open Page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.popoverPresentationController?.barButtonItem = openButton //for ipad
        present(ac, animated: true, completion: nil)
    }

    private func openPage(action: UIAlertAction) {
        if let urlTitle = action.title {
            if let urll = URL(string: "https://" + urlTitle) {
                webView.load(URLRequest(url: urll))
            }
        }
    }
    
    

}


//MARK: - Extension

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let urlll = navigationAction.request.url
        
        if let host = urlll?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        decisionHandler(.cancel)
    }
}
