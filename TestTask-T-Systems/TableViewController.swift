//
//  TableViewController.swift
//  TestTask-T-Systems
//
//  Created by Andrei Konovalov on 06.02.2020.
//  Copyright © 2020 Andrei Konovalov. All rights reserved.
//
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet weak var tableview: UITableView!
  var counter = 1
  var filmsData = [res?]()
  let picPath = "https://image.tmdb.org/t/p/w1280/"
  let imageCache = NSCache<NSString, UIImage>()
  let searchString = "https://api.themoviedb.org/3/discover/movie?primary_release_year=2019&api_key=d0813c436b68b136e616b9e2af7d1ac4&language=en-US&sort_by=popularity.desc&include_video=false&page="

  @IBAction func showCalendar(_ sender: Any) {
    guard let url = URL(string: "calshow://") else { return }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }

  func formateDate(input date:String)->String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"  //
    if let myDate = dateFormatter.date(from: date) {
      dateFormatter.dateFormat = "MMMM d, yyyy"
      return(dateFormatter.string(from: myDate))
    }
    return ""
  }

  func GetData(url:URL, ErrorHandler: @escaping (Error?) -> Void){
    _ = URLSession.shared.dataTask(with: url) { data,response,error in
      if let error = error {
        print("error: \(error)")
        ErrorHandler(error)
      } else {
        if let response = response as? HTTPURLResponse {
          print("statusCode: \(response.statusCode)")
          ErrorHandler(nil)
        }
        if let data = data {
          do{
            let dataFromPage = try JSONDecoder().decode(MovieResult.self, from: data)
            for i in 0..<dataFromPage.results.count{
              self.filmsData.append(dataFromPage.results[i])
            }
            DispatchQueue.main.async{
              self.tableview?.reloadData()
            }
            ErrorHandler(nil)
          } catch let parsingError {
            print("Error", parsingError)
            ErrorHandler(parsingError)
          }
        }
      }
    }.resume()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    tableview.delegate = self
    tableview.dataSource = self
    let searchURl = URL(string:searchString + "\(counter)")!
    self.GetData(url: searchURl,ErrorHandler:{error in
      if let error = error {
        DispatchQueue.main.async {
          let alert = UIAlertController(title: "Alert", message: "Error: \(String(describing: error)))", preferredStyle: UIAlertController.Style.alert)
          alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
          self.present(alert, animated: true, completion: nil)
        }
      }
    })
  }
  // MARK: - Table view data source
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return filmsData.count
  }


  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let urlString = picPath + (filmsData[indexPath.row]?.poster_path!)!

    if indexPath.row == (filmsData.count - 1){
      counter = counter + 1
      let searchURl = URL(string:searchString + "\(counter)")!
      self.GetData(url: searchURl,ErrorHandler:{error in
        if error != nil {
          DispatchQueue.main.async {
            let alert = UIAlertController(title: "Alert", message: "Error: \(String(describing: error)))", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
          }
        }
      })
    }
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "FilmInfoCell",for: indexPath) as? TableViewCell else { return UITableViewCell() }
    guard let cellData = filmsData[indexPath.row] else{
      return cell
    }
    cell.mainImage?.image = nil
    cell.filmName?.text = cellData.title
    cell.date?.text = formateDate(input: cellData.release_date ?? "")
    cell.filmDescription?.text = cellData.overview
    cell.scoreLable?.text = String(format:"%.0f", ((cellData.vote_average ?? 0.0) * 10))
    cell.scoreLable?.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    cell.selectionStyle = .none

    cell.mainImage?.image = imageCache.object(forKey:NSString(string: urlString))
    if cell.mainImage?.image == nil{
      cell.imageURL = URL(string: picPath + (filmsData[indexPath.row]?.poster_path!)!)
      if let url = cell.imageURL{
        DispatchQueue.global(qos: .utility).async {
          if let data = try? Data(contentsOf: url){
            self.imageCache.setObject(UIImage(data: data)!, forKey: NSString(string: urlString))
            DispatchQueue.main.async {
              if let cellToUpdate = tableView.cellForRow(at: indexPath) as? TableViewCell {
                cellToUpdate.mainImage?.image = self.imageCache.object(forKey: NSString(string: urlString))
              }
            }
          }
        }
      } else { cell.imageView?.image = UIImage(systemName: "Image")}
    }
    return cell
  }


  func tableView(_ tableview: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableview.deselectRow(at: indexPath, animated: false)
  }

  override open var shouldAutorotate: Bool {
    return false
  }

  override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }
}



