//
//  TableViewController.swift
//  wisdom-leaf
//
//  Created by Kibbcom on 25/06/24.
//

import UIKit

class TableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var data: [Item] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        
        // Add pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        // Fetch data
        fetchData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func fetchData() {
        guard let url = URL(string: "https://picsum.photos/v2/list?page=2&limit=20") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, let data = data, error == nil else {
                print("Failed to fetch data")
                return
            }
            
            do {
                let items = try JSONDecoder().decode([Item].self, from: data)
                DispatchQueue.main.async {
                    self.data = items
                    self.tableView.reloadData()
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }
        
        task.resume()
    }
    @objc func refreshData() {
        fetchData()
        tableView.refreshControl?.endRefreshing()
    }
}
extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as? ItemCell else {
                return UITableViewCell()
            }
            
            let item = data[indexPath.row]
            cell.titleLabel.text = item.author
        cell.descriptionLabel.text = item.url
            if let imageUrl = URL(string: item.download_url) {
                cell.itemImageView.loadImage(from: imageUrl, placeholder: UIImage(named: "placeholder"))
            }
        cell.checkboxButton.setImage(item.isChecked ? UIImage(named: "ic_checkbox") : UIImage(named: "ic_uncheckbox") , for: .normal)
            
            cell.checkboxHandler = { [weak self] in
                self?.data[indexPath.row].isChecked.toggle()
                tableView.reloadData()
            }
            
            return cell
        }
}
extension TableViewController: UITableViewDelegate {
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        if item.isChecked {
            let alert = UIAlertController(title: "Description", message: item.url, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Checkbox is not selected", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}
extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder

        // Check if the image is already cached
        if let cachedImage = ImageCache.shared.getImage(forKey: url.absoluteString) {
            self.image = cachedImage
            return
        }

        // Download image from URL
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let downloadedImage = UIImage(data: data) else {
                return
            }

            // Cache the downloaded image
            ImageCache.shared.saveImage(downloadedImage, forKey: url.absoluteString)

            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }

        task.resume()
    }
}

class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    private init() {}
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    func saveImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
