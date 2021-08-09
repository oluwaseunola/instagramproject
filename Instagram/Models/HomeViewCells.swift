//
//  HomeViewCells.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-07-19.
//

import Foundation

enum HomeViewCellsType{
    
    case poster(viewModel: PosterCollectionViewModel)
    case post(viewModel: PostCollectionViewModel)
    case actions(viewModel: ActionsViewModel)
    case likes(viewModel:CommentsViewModel )
    case caption(viewModel: CaptionCollectionViewModel)
    case timeStamp(viewModel: DateTimeCollectionViewModel)
    
}
