//
//  BreakingBadAPI.swift
//  BreakingBad
//
//  Created by Brendan Rogan on 12/4/20.
//

import Foundation

enum BreakingBadAPIErrors : Error {
    case BadURLError
    case NoDataError
    case CharactersDecodingError
}

struct BreakingBadAPI {
    
    static func getCharacters(completion: @escaping (Result<[Character], Error>) -> Void) {
        guard let url = URL(string: "https://breakingbadapi.com/api/characters") else {
            return completion(.failure(BreakingBadAPIErrors.BadURLError))
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                return completion(.failure(error))
            }

            guard let data = data else {
                return completion(.failure(BreakingBadAPIErrors.NoDataError))
            }
            
            var characters = [Character]()
            let decoder = JSONDecoder()
            do {
                characters = try decoder.decode([Character].self, from: data)
            } catch {
                return completion(.failure(BreakingBadAPIErrors.CharactersDecodingError))
            }
            return completion(.success(characters))
        }
        task.resume()
    }
    
}
