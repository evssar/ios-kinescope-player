//
//  File.swift
//  
//
//  Created by Eugene Sorokin on 16.11.2022.
//

import Foundation
import M3U8Decoder

struct MasterPlaylist: Decodable {
    let extm3u: Bool
    let ext_x_version: Int
    let ext_x_independent_segments: Bool
    let ext_x_media: [EXT_X_MEDIA]
    let ext_x_stream_inf: [EXT_X_STREAM_INF]
    let ext_x_i_frame_stream_inf: [EXT_X_I_FRAME_STREAM_INF]?
    let uri: [String]
}
