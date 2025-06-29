//
//  PlaylistThumbnailView.swift
//  TestBCA
//
//  Created by reyhan muhammad on 2025/6/30.
//
import SwiftUI

struct PlaylistThumbnailView: View {
    @Binding var audios: Audios
    var body: some View {
        HStack{
            let count = min(3, audios.audios.count)
            ForEach(0..<count, id: \.self){ index in
                var audiosReversed = audios.audios
                let thumbnailImage = audiosReversed[audios.audios.count - 1 - index].artworkUrl100 ?? ""
                AsyncImage(url: URL(string: thumbnailImage)).aspectRatio(contentMode: .fit).frame(width: 50, height: 50).clipShape(RoundedRectangle(cornerRadius: 10)).offset(x: CGFloat(3 - index) * CGFloat(50) / CGFloat(2))
                    .shadow(radius: 2)
            }
        }.padding(.trailing, 25)
    }
}
