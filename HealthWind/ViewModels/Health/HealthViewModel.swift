//
//  HealthViewModel.swift
//  HealthWind
//
//  Created by Rafael Alejandro Rivas González on 17/10/24.
//

import Foundation
import SwiftUI
import OpenAI

@Observable
class HealthViewModel: ObservableObject {
    let openAI = OpenAI(apiToken: "")
    var result: String = ""
    var recommendations: [String] = []
    var loadedRecommendationes: Bool = false
    
    func getChatReply() async {
        let query = ChatQuery(messages: [.init(role: .user, content: "Give me in spanish three health recommendations for the user, knowing that she is a 27-year-old woman with a BMI of 24 and asthma. With an air quality index of 20, which is very good. Separated by only commas whitout spaces after commas, uppercase only the first letter of each recommendation, dont use any other separator, and only the recommendations.")!], model: .gpt4_o)
                openAI.chats(query: query) { result in
                    switch result {
                    case .success(let success):
                        guard let choice = success.choices.first else {
                            return
                        }
                        guard let message = choice.message.content?.string else { return }
                        DispatchQueue.main.async {
                            self.result = message
                            let recommendations = message.split(separator: ",")
                            for recommendation in recommendations {
                                self.recommendations.append(String(recommendation))
                                print(String(recommendation))
                            }
                            
                        }
                    case .failure(let failure):
                        print(failure)
                    }
                }
        self.loadedRecommendationes = true
        }
}