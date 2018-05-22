//
//  ViewController.swift
//  urlSessionDemo1
//
//  Created by opto on 2018/5/22.
//  Copyright © 2018年 Tiger. All rights reserved.
//

import UIKit

struct ShopInfo: Codable {
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var name: String?
    var phone: String?
    
}
struct FoodShop : Codable {
    
    var results: [ShopInfo]
}


class ViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    
    @IBOutlet weak var PhotoImage: UIImageView!
    

    @IBAction func search(_ sender: Any) {
        let session = URLSession.shared
        
        let url = URL(string: "https://food-locator-dot-hpd-io.appspot.com/v1/location_query?latitude=25.0810903271646&longitude=121.557605682453&distance=1.0")!
        print("\(url)")
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print("fail to get data: \(err)")
                return
                
            }
            let data = data!
            print("\(data)")
            /*
            let decoder = JSONDecoder()
            if let jsonData = try? decoder.decode(FoodShop.self, from: data) {
                print("\(jsonData.results[0].address!)")
            }
            else {
               print("fail to parse data: ")
            }
            */
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                if let results = jsonObject as? [[String: Any]] {
                    if results.count == 0 {
                        print("Can't find any restruant")
                        return
                    }
                    let randomIndex = Int(arc4random_uniform(UInt32(results.count)))
                    let result = results[randomIndex]
                    
                   // let photo = UIImage(imageLiteralResourceName: result["photo"] as! String)
                    print("\(results[randomIndex])")
                    DispatchQueue.main.async {
                        self.nameLabel.text = result["name"] as? String
                        self.addressLabel.text = result["address"] as? String                        
                        self.latitudeLabel.text = "\(result["latitude"] as! Double)"
                        self.longitudeLabel.text = "\(result["longitude"] as! Double)"
                        self.ratingLabel.text = "\(result["rating"] as! Double)"
                        self.phoneLabel.text = result["phone"] as? String
                       // self.PhotoImage.image = photo
                    }
                }
                
            }
            
            
        }
        task.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

