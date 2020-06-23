# Easy Browser

In this project #4 of HackingWithSwift.com, I use Swift's Webkit to load websites, UIToolBar and UIProgressView to refresh and show the progress of loading, and finally use WKNavigationDelegate methods to allow or reject visiting certain websites.

<img src="https://github.com/igibliss00/EasyBrowser/blob/master/README_assets/1.png" width="400">
<img src="https://github.com/igibliss00/EasyBrowser/blob/master/README_assets/2.png" width="400">

## Installing

Clone the project with the following command
```
git clone https://github.com/igibliss00/EasyBrowser.git
```

## Features

### UIToolBar

UIToolBar is the subclass of UIView that holds and shows a collection of UIBarButtonItem objects.
```
let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))

toolbarItems = [progressButton, spacer, refresh]
navigationController?.isToolbarHidden = false
```
Here in the code, I didn't have to initialize the variable "toolbarItems" because all view controllers under UINavigationController automatically come with the property.  It's important to note that the "toolBarItems" doesn't all accept just any kind of "UIToolBar" subclasses.  They first have to be wrapped in "UIBarButtonItem" as seen above, as well as for the progress view later on.  

### UIProgressView

UIProgressView is also a subclass of the UIView class.  This class is to show the how far a certain task is completed.  

The "progressView" is first declared with the type "UIProgressView":
```
var progressView: UIProgressView!
```

Then, the property is initialized with the constructor:
```
progressView = UIProgressView(progressViewStyle: .default)
```

### Key Value Observing

Key-Value Observing (KVO) is a concept similar to the subscription in GraphQL or Observable in Angular.  It's a mechanism where the observer can be notified of any changes to the property of your choice.  More specifically, we are going to be observing the value of a certain key.  This project shows KVO that consists of two parts.

First part is adding the observer:
```
webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
```
I added the observer to "webView" using the "addObserver" method.  The first parameter "self" is to indicate who the observer will be.  The second parameter is to indicate which key will be observed for any changes.  The third parameter is to indicate that the observer wants to be notified any new changes.

The second part is defining the function to be called in response to any changes to the observed target.

```
override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "estimatedProgress" {
        progressView.progress = Float(webView.estimatedProgress)
    }
}
```
This function feeds the changes from web view's "estimatedProgress" to the UI element, which is "progressView.progress" as they happen.  The conversion is done through "Float()" because "esimatedProgress" is Double.  This function allows the progress update to be witnessed on the tool bar as the websites load. 


### DecidePolicyFor

The "WKNavigationDelegate" provides more fine-grained control over which website is allowed access from our web view.  

```
var websites = ["apple.com", "hackingwithswift.com"]

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

    decisionHandler(.cancel)
}
```
By specifying which websites are allowed in the "websites" array to be visited or not, the closure "decisionHandler" will execute either ".allow" or ".cancel"


