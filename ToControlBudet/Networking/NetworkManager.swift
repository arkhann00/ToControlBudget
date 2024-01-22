//
//  NetworkManager.swift
//  ToControlBudet
//
//  Created by Арсен Хачатрян on 21.12.2023.
//

import Foundation

//MARK: - Ответственен за ошибки
enum NetworkError: Error {
    case invalidURL, decodingError, noData
}

final class NetworkManager {
    //MARK: - Синглтон
    static let shared = NetworkManager()
    
    private init() {}
    
    //MARK: - Извлечение из сети курса валют
    func fetchCurrency(completion: @escaping (Result<[String : Double], NetworkError>) -> Void){
        
        URLSession.shared.dataTask(with: Link.currency.url) { data, response, error in
//            if let response = response as? HTTPURLResponse{
//                print("response: \(response.statusCode)")
//            }
            
            guard let data else {
                print(error?.localizedDescription ?? "No error description")
                completion(.failure(.noData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let currencyConverter = try decoder.decode(CurrencyConverter.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(currencyConverter.rates))
                    
                }
                
            }
            catch {
                completion(.failure(.decodingError))
            }
        } .resume()
    }
}

//MARK: - Link

extension NetworkManager {
    
    enum Link {
        
        case currency
        
        var url:URL {
            switch self {
            case.currency:
                return URL(string: "https://www.cbr-xml-daily.ru/latest.js")!
            }
        }
        
    }
    
}
