//
//  DefaultInterestShowUseCase.swift
//  ShowPot
//
//  Created by 이건준 on 8/16/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DefaultInterestShowUseCase: InterestShowUseCase {
    
    private let showAPI = SPShowAPI()
    private let disposeBag = DisposeBag()
    
    var interestShowList: RxRelay.BehaviorRelay<[ShowSummary]> = BehaviorRelay<[ShowSummary]>(value: [])
    
    func deleteInterestShow(_ show: ShowSummary) {
        LogHelper.debug("공연 관심 해제: \(show)")
        showAPI.deleteInterest(showId: show.id)
            .subscribe(onDisposed:  {
                self.requestInterestShowData()
            }).disposed(by: disposeBag)
    }
    
    func requestInterestShowData() {
        
        showAPI.interestList()
            .map { response in
                response.data.map { data in
                    ShowSummary(
                        id: data.id,
                        thumbnailURL: URL(string: data.posterImageURL),
                        title: data.title,
                        location: data.location,
                        time: data.startAt.date("yyyy.MM.dd")
                    )
                }
            }.bind(to: interestShowList)
            .disposed(by: disposeBag)
    }
}
