import UIKit
import Foundation

private let imageLoaderQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 5
    return queue
}()

private let imageCache = NSCache<NSURL, UIImage>()
    
public extension UIImageView {
    private struct AssociatedKeys {
        static var currentURLKey: UInt8 = 0
        static var loadingIndicatorKey: UInt8 = 1
    }
    
    private var currentURL: URL? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.currentURLKey) as? URL
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.currentURLKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var loadingIndicator: UIActivityIndicatorView? {
        get {
            if let spinner = objc_getAssociatedObject(self, &AssociatedKeys.loadingIndicatorKey) as? UIActivityIndicatorView {
                return spinner
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadingIndicatorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private func startLoading() {
        if loadingIndicator == nil {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            addSubview(spinner)
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            loadingIndicator = spinner
        }
        loadingIndicator?.startAnimating()
    }
    
    private func stopLoading() {
        loadingIndicator?.stopAnimating()
    }
    
    func loadImageByPod(from url: URL,
                   placeholder: UIImage? = nil,
                   failedImage: UIImage? = nil,
                   loadingIndicator: UIActivityIndicatorView? = nil) {
        self.currentURL = url
        self.image = placeholder
        if loadingIndicator != nil {
            self.loadingIndicator = loadingIndicator
        }
        startLoading()
        if let cache = imageCache.object(forKey: url as NSURL) {
            self.image = cache
            stopLoading()
            return
        }
        imageLoaderQueue.addOperation { [weak self] in
            guard let self = self else { return }
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    guard self.currentURL == url else { return }
                    self.stopLoading()
                    self.image = failedImage
                }
                return
            }
            imageCache.setObject(image, forKey: url as NSURL)
            DispatchQueue.main.async {
                guard self.currentURL == url else { return }
                self.image = image
                self.stopLoading()
            }
        }
    }
}
