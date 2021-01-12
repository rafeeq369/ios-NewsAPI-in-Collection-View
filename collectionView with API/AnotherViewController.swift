//
//  AnotherViewController.swift
//  collectionView with API
//
//  Created by intelmac on 11/01/21.
//

import UIKit

class AnotherViewController: UIViewController, UIScrollViewDelegate {

    
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var previewImg: UIView!
    @IBOutlet weak var Prviewpic: UIImageView!
    
        var details: Article!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        author?.text = details.author
//        content?.text = details.content
        // Do any additional setup after loading the view.
        let string = details.urlToImage ?? ""
        if let image = getImage(from: string) {
            foto!.image = image
        }
        

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchHappen(_:)))
        foto.addGestureRecognizer(tap)
        foto.isUserInteractionEnabled = true

    }
    
    @objc func touchHappen(_ sender: UITapGestureRecognizer) {
        print("Hello Dear you are here")
        let string = details.urlToImage ?? ""
        if let images = getImage(from: string) {
            foto!.image = images
            Prviewpic.image = images
        }
        previewImg.isHidden = false
    }
    @IBAction func cancelPreview(_ sender: Any) {
        previewImg.isHidden = true
    }
    // MARK: - Navigation

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

    @IBAction func backToCV(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
