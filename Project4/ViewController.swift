//
//  ViewController.swift
//  Project4
//
//  Created by jc on 2020-06-21.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView:UIProgressView!
    var websites = ["apple.com", "hackingwithswift.com", "google.com", "reddit.com"]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let goBack = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(title: ">", style: .plain, target: self, action: #selector(webView.goForward))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [goBack, goForward, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem // for iPads
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "http://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        let ac = UIAlertController(title: "Warning", message: "Unauthorized visit to a website", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
        decisionHandler(.cancel)

    }
}

