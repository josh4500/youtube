/*
 *  Copyright (c) 2023, Ajibola Akinmosin (https://github.com/josh4500)
 *
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without modification,
 *  are permitted provided that the following conditions are met:
 *
 *      * Redistributions of source code must retain the above copyright notice,
 *        this list of conditions and the following disclaimer.
 *      * Redistributions in binary form must reproduce the above copyright notice,
 *        this list of conditions and the following disclaimer in the documentation
 *        and/or other materials provided with the distribution.
 *      * Neither the name of {{ project }} nor the names of its contributors
 *        may be used to endorse or promote products derived from this software
 *        without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 *  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 *  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 *  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 *  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

class Caption {
  Caption({
    this.videoId,
    this.lastUpdated,
    this.trackKind,
    this.language,
    this.name,
    this.audioTrackType,
    this.isCC,
    this.isLarge,
    this.isEasyReader,
    this.isDraft,
    this.isAutoSynced,
    this.status,
    this.failureReason,
  });

  Caption.fromJson(dynamic json) {
    videoId = json['videoId'];
    lastUpdated = json['lastUpdated'];
    trackKind = json['trackKind'];
    language = json['language'];
    name = json['name'];
    audioTrackType = json['audioTrackType'];
    isCC = json['isCC'];
    isLarge = json['isLarge'];
    isEasyReader = json['isEasyReader'];
    isDraft = json['isDraft'];
    isAutoSynced = json['isAutoSynced'];
    status = json['status'];
    failureReason = json['failureReason'];
  }
  String? videoId;
  String? lastUpdated;
  String? trackKind;
  String? language;
  String? name;
  String? audioTrackType;
  String? isCC;
  String? isLarge;
  String? isEasyReader;
  String? isDraft;
  String? isAutoSynced;
  String? status;
  String? failureReason;
  Caption copyWith({
    String? videoId,
    String? lastUpdated,
    String? trackKind,
    String? language,
    String? name,
    String? audioTrackType,
    String? isCC,
    String? isLarge,
    String? isEasyReader,
    String? isDraft,
    String? isAutoSynced,
    String? status,
    String? failureReason,
  }) =>
      Caption(
        videoId: videoId ?? this.videoId,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        trackKind: trackKind ?? this.trackKind,
        language: language ?? this.language,
        name: name ?? this.name,
        audioTrackType: audioTrackType ?? this.audioTrackType,
        isCC: isCC ?? this.isCC,
        isLarge: isLarge ?? this.isLarge,
        isEasyReader: isEasyReader ?? this.isEasyReader,
        isDraft: isDraft ?? this.isDraft,
        isAutoSynced: isAutoSynced ?? this.isAutoSynced,
        status: status ?? this.status,
        failureReason: failureReason ?? this.failureReason,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['videoId'] = videoId;
    map['lastUpdated'] = lastUpdated;
    map['trackKind'] = trackKind;
    map['language'] = language;
    map['name'] = name;
    map['audioTrackType'] = audioTrackType;
    map['isCC'] = isCC;
    map['isLarge'] = isLarge;
    map['isEasyReader'] = isEasyReader;
    map['isDraft'] = isDraft;
    map['isAutoSynced'] = isAutoSynced;
    map['status'] = status;
    map['failureReason'] = failureReason;
    return map;
  }
}
