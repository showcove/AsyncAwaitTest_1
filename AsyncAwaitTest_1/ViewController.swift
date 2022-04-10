//
//  ViewController.swift
//  AsyncAwaitTest_1
//
//  Created by jay on 2022/04/10.
//

import UIKit

enum TestError: Error {
    case defaultError
}

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var imageView6: UIImageView!
    @IBOutlet weak var imageView7: UIImageView!
    @IBOutlet weak var imageView8: UIImageView!
    @IBOutlet weak var imageView9: UIImageView!
    
    
    var imageViews: [UIImageView] = []
    let imageAddresses: [URL] = [
        URL(string:"https://cdn.pixabay.com/photo/2018/10/05/23/31/apple-3727110_1280.jpg")!, // big
        URL(string:"https://cdn.pixabay.com/photo/2016/08/12/22/38/apple-1589874_1280.jpg")!,
        URL(string:"https://cdn.pixabay.com/photo/2016/08/12/22/34/apple-1589869_1280.jpg")!,
        URL(string:"https://cdn.pixabay.com/photo/2020/05/18/19/14/apple-5188076_1280.jpg")!, // big
        URL(string:"https://cdn.pixabay.com/photo/2016/11/29/08/41/apple-1868496_1280.jpg")!,
        URL(string:"https://cdn.pixabay.com/photo/2016/01/05/13/58/apple-1122537_1280.jpg")!,
        URL(string:"https://cdn.pixabay.com/photo/2016/11/30/15/23/apples-1873078_1280.jpg")!,
        URL(string:"https://cdn.pixabay.com/photo/2016/11/18/13/47/apple-1834639_1280.jpg")!,
        URL(string:"https://cdn.pixabay.com/photo/2015/01/21/14/14/apple-606761_1280.jpg")!
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageViews = [imageView1, imageView2, imageView3, imageView4, imageView5, imageView6, imageView7, imageView8, imageView9]
    }
    
    func waitAndReturnDelay(_ delay: TimeInterval) async -> TimeInterval {
        Thread.sleep(forTimeInterval: delay)
        print("\(delay) 초가 지났습니다.")
        return delay
    }
    
    func downloadImageData(index: Int) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: imageAddresses[index], delegate: nil)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw TestError.defaultError
        }
        
        print("download : (\(index)) completed")
        
        return data
    }
    
    func fillImageWith(data: Data, index: Int) {
        if let image = UIImage(data: data) {
            imageViews[index].image = image
        }
    }
    
    @IBAction func startSingleAsyncAwait() {
        Task {
            let value = await waitAndReturnDelay(3)
            
            let alert = UIAlertController(title: "완료",
                                          message: "\(value)초가 지났습니다.",
                                          preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
            alert.addAction(closeAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func startMultiAsyncAwaitSerial() {
        Task {
            let imageData0 = try await downloadImageData(index: 0)
            fillImageWith(data: imageData0, index: 0)

            let imageData1 = try await downloadImageData(index: 1)
            fillImageWith(data: imageData1, index: 1)
            
            let imageData2 = try await downloadImageData(index: 2)
            fillImageWith(data: imageData2, index: 2)

            let imageData3 = try await downloadImageData(index: 3)
            fillImageWith(data: imageData3, index: 3)

            let imageData4 = try await downloadImageData(index: 4)
            fillImageWith(data: imageData4, index: 4)

            let imageData5 = try await downloadImageData(index: 5)
            fillImageWith(data: imageData5, index: 5)

            let imageData6 = try await downloadImageData(index: 6)
            fillImageWith(data: imageData6, index: 6)

            let imageData7 = try await downloadImageData(index: 7)
            fillImageWith(data: imageData7, index: 7)
            
            let imageData8 = try await downloadImageData(index: 8)
            fillImageWith(data: imageData8, index: 8)

//            for currentIndex in 0...8 {
//                let imageData = try await downloadImageData(index: currentIndex)
//               fillImageWith(data: imageData, index: currentIndex)
//            }
        }
    }
    
    @IBAction func startMultiAsyncAwaitParallel() {
        Task {
            async let imageData0 = downloadImageData(index: 0)
            async let imageData1 = downloadImageData(index: 1)
            async let imageData2 = downloadImageData(index: 2)
            async let imageData3 = downloadImageData(index: 3)
            async let imageData4 = downloadImageData(index: 4)
            async let imageData5 = downloadImageData(index: 5)
            async let imageData6 = downloadImageData(index: 6)
            async let imageData7 = downloadImageData(index: 7)
            async let imageData8 = downloadImageData(index: 8)
            
            let imageDatum = try await [imageData0, imageData1, imageData2, imageData3, imageData4, imageData5, imageData6, imageData7, imageData8]
            
            for (index, imageData) in imageDatum.enumerated() {
                fillImageWith(data: imageData, index: index)
            }
        }
    }
    
    @IBAction func clearImageViews() {
        for imageView in imageViews {
            imageView.image = nil
        }
    }

}

