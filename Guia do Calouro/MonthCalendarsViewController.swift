//
//  MonthCalendarsViewController.swift
//  Guia do Calouro
//
//  Created by Daniel Araújo on 10/02/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class MonthCalendarsViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!

    var chave = "calendars"
    var calendars = [Calendar]()
    var tmp = [String]()
    var conteudo: MonthCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Calendário - \(conteudo.name!)"
        let url = UrlProvider.Instance.lerUrl(sufix: "calendars.json")
        self.CallAlomo(url: url)
    }
    
    
    func CallAlomo(url:String){
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            self.parseData(JSONData: response.data!)
        });
        
    }
    
    func parseData(JSONData: Data){
        let carregamento = UserDefaults.standard.object(forKey: self.chave) as! NSDictionary
        
        let methodStart = Date()
        SVProgressHUD.show(withStatus: "Carregando")
        
        do{
            let json = try JSONSerialization.jsonObject(with: JSONData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            
            
            if carregamento != nil{
                
                let calendarDictionaries = carregamento["calendars"] as! [[String:AnyObject]]
                for calendarDictionary in calendarDictionaries{
                    let newCalendar = Calendar(array: calendarDictionary)
                    self.calendars.append(newCalendar)
                }
                
                for calendar in calendars{
                    if( conteudo.id! == calendar.month_calendar_id){
                        self.tmp.append(calendar.name!)
                    }
                }
            
                OperationQueue.main.addOperation {
                    SVProgressHUD.dismiss()
                    self.tableView.reloadData()
                    
                }
                
                //print(self.tmp)
                
                
                
                
            }else{
                print("Encontrou nulo")
            }
            
        } catch let erro as NSError {
            print("Aconteceu um erro de sessão! \(erro.description)")
            SVProgressHUD.dismiss()
            //self.showAlert(title: "Aconteceu algum problema", message: "\(erro.description)")
        }
        
        let methodFinally = Date()
        let execulteTime = methodFinally.timeIntervalSince(methodStart)
        print(execulteTime)
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tmp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "MonthCell", for: indexPath)
        celula.textLabel?.text = self.tmp[indexPath.row]
        
        return celula;
        
    }
    


}
