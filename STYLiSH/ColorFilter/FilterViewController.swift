//
//  FilterViewController.swift
//  STYLiSH
//
//  Created by Hueijyun  on 2020/1/5.
//  Copyright © 2020 WU CHIH WEI. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ColorViewControllerDelegate {
    
    //儲存filter的結果
    var result: [Product1] = []
    func receiveData(data: String) {
        //清空上一次filter的結果
        result = []
        
        for item in productItem {
          
            for colorcode in item.colors {
            
                if colorcode.code == data {
                    print(colorcode)
                    print(item)
                    
                    result.append(item)
                    
                }
            }
        }
        filterTableView.reloadData()
    }
    
    @IBOutlet var filterTableView: UITableView!
    
    @IBAction func filterbutton(_ sender: Any) {

    }
    
    var productItem: [Product1] = [] {
        didSet {
            result = productItem
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterTableView.delegate = self
        filterTableView.dataSource = self
        getProduct(url: men)
        getProduct(url: women)
        getProduct(url: accessories)
    
    }
    //連接colorViewController的segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "colorSegue"{
            guard let colorViewController = segue.destination as? ColorViewController else { return }
            colorViewController.delegate = self
        }
            
    }
    var accessories = "https://api.appworks-school.tw/api/1.0/products/accessories"
    var women = "https://api.appworks-school.tw/api/1.0/products/women"
    var men = "https://api.appworks-school.tw/api/1.0/products/men"
    
    func getProduct( url: String) {
        
        let session = URLSession(configuration: .default)
        
        let request = URLRequest(url: URL (string: url)!)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else { return }
            let decoder = JSONDecoder()
            if let loadData = data {
                do {
                    let respondseData = try decoder.decode(Menu.self, from: loadData)
                    print(respondseData)
                    
                    self.productItem += respondseData.data
                    
                    DispatchQueue.main.async {
                        self.filterTableView.reloadData()
                    }
                    
                } catch {
                    
                    print(error)
                }
            }
        }
        
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return result.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "catalog1", for: indexPath) as? FilterTableViewCell else {
            return UITableViewCell()
        }
        let imageString = result[indexPath.row].mainImage
        let url = URL(string: imageString)
        cell.catalogImageView.kf.setImage(with: url)
        cell.catalogPrice.text = "NT$\(String(result[indexPath.row].price))"
        cell.catalogTitle.text = result[indexPath.row].title
        return cell
        
    }
}
