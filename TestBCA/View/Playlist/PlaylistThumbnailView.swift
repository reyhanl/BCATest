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
            ForEach(0..<audios.audios.count, id: \.self){ index in
                let thumbnailImage = audios.audios[index].artworkUrl100 ?? ""
                AsyncImage(url: URL(string: thumbnailImage)).aspectRatio(contentMode: .fit).frame(width: 50, height: 50).clipShape(RoundedRectangle(cornerRadius: 10)).offset(x: -CGFloat(index) * CGFloat(50) / CGFloat(2))
            }
        }
    }
}
