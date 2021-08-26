//
//  SinglePost.swift
//  Instagram
//
//  Created by Seun Olalekan on 2021-08-19.
//

import Foundation

enum SinglePostType{
    
    case poster(viewModel: PosterCollectionViewModel)
    case post(viewModel: PostCollectionViewModel)
    case actions(viewModel: ActionsViewModel)
    case likes(viewModel:LikesViewModel )
    case caption(viewModel: CaptionCollectionViewModel)
    case timeStamp(viewModel: DateTimeCollectionViewModel)
    case comments(viewModel: CommentsModel)
    
}
