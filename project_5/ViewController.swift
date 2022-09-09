//
//  ViewController.swift
//  project_5
//
//  Created by Ruçhan Talha Günay on 30.08.2022.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var websites = ["hackingwithswift.com", "apple.com"]
    //var website: String!

    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://" + websites[1])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let forward = UIBarButtonItem(title: "F", style: .plain, target: webView, action: #selector(webView.goForward))
        let backward = UIBarButtonItem(title: "B", style: .plain, target: webView, action: #selector(webView.goBack))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        let progressButton = UIBarButtonItem(customView: progressView)
        navigationController?.isToolbarHidden = false
        
        
        toolbarItems = [backward, forward, progressButton, spacer, refresh]
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        
    }
    
    @objc func openTapped(){
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else{
            return
        }
        guard let url = URL(string: "https://" + actionTitle) else {
            return
        }
        
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath : String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url
        let ac = UIAlertController(title: "BLOCKED", message: "This site is blocked.", preferredStyle: .alert)
        
       
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
                
            }
            
            present(ac, animated: true)
            ac.dismiss(animated: true)
            
        }
    
            decisionHandler(.cancel)
            
        
    }
    
    


}

