//
//  ViewController.swift
//  collectionView with API
//
//  Created by intelmac on 10/01/21.
//

import UIKit

struct NewsFeed: Codable {
    var status:String? = ""
    var totalResults:Int = 0
    var articles:[Article]?
}

struct Article: Codable {
    var author:String?
    var title:String?
    var discription:String?
    var url:String?
    var urlToImage:String?
    var publishedAt:String?
    var content:String?
}

class ViewController: UIViewController {
    
    var finalArray = [Article]()
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        let urlString = "http://newsapi.org/v2/everything?q=bitcoin&from=2020-12-11&sortBy=publishedAt&apiKey=04a965d278584c2b830e1e266e558dca"
        let url = URL(string: urlString)

            guard url != nil else {
                return
            }

        _ = URLSession.shared


        let dataTask = URLSession.shared.dataTask(with: url!) { [self](data, response, error) in
            if error == nil && data != nil {
                do {
                    let newsFeed = try JSONDecoder().decode(NewsFeed.self, from: data!)
                    finalArray = newsFeed.articles!
                    if finalArray.count > 0 {
                       
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            self.collectionView.delegate = self
                            self.collectionView.dataSource = self
                        }

                    }
                    
                }
                catch{
                    print("error in JSON String............................................")
                }
            }
        }
        dataTask.resume()
    }
}


extension ViewController :  UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func getImage(from string: String) -> UIImage? {
        
        var defaultimg = string == "" ? "https://images.freeimages.com/images/large-previews/f2c/effi-1-1366221.jpg" : string
        //2. Get valid URL
        guard let url = URL(string: string)
            else {
                print("Unable to create URL")
                return nil
        }

        var image: UIImage? = nil
        do {
            //3. Get valid data
            let data = try Data(contentsOf: url, options: [])

            //4. Make image
            image = UIImage(data: data)
        }
        catch {
            print(error.localizedDescription)
        }

        return image
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return finalArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! CollectionViewCells
        let value = finalArray[indexPath.row]
        let string = value.urlToImage ?? ""
        if let image = getImage(from: string) {
            cell.cellImage.layer.cornerRadius = 12
            cell.cellImage!.image = image
           
        }

//    cell.cellTitle?.text = value.author
//    cell.cellContent?.text = value.author
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let value = finalArray[indexPath.row]

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "YourViewController") as! AnotherViewController
        destination.details = value
        self.navigationController?.pushViewController(destination, animated: true)
        
    }
    
}




