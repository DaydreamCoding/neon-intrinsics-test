// Tencent is pleased to support the open source community by making ncnn available.
//
// Copyright (C) 2017 THL A29 Limited, a Tencent company. All rights reserved.
//
// Licensed under the BSD 3-Clause License (the "License"); you may not use this file except
// in compliance with the License. You may obtain a copy of the License at
//
// https://opensource.org/licenses/BSD-3-Clause
//
// Unless required by applicable law or agreed to in writing, software distributed
// under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
#pragma once

#include <cstdlib>
#include <cstring>

/**
 * reference https://github.com/Tencent/ncnn/blob/f42d0e5dc9ebe5ff3a76c176b79136d1f7657703/src/mat_pixel_affine.cpp
 */
class WarpAffine {
public:
    WarpAffine() = delete;
    ~WarpAffine() = delete;

public:
    // resolve affine transform matrix from rotation angle, scale factor and x y offset
    static void get_rotation_matrix(float angle, float scale, float dx, float dy, float* tm);
    // resolve affine transform matrix from two set of points, num_point must be >= 2
    static void get_affine_transform(const float* points_from, const float* points_to, int num_point, float* tm);
    // resolve the inversion affine transform matrix
    static void invert_affine_transform(const float* tm, float* tm_inv);

public:
    // image pixel bilinear warpaffine transform with stride(bytes-per-row) parameter, set -233 for transparent border color, the color RGBA is little-endian encoded
    static void warpaffine_bilinear_c1(const unsigned char* src, int srcw, int srch, int srcstride, unsigned char* dst, int w, int h, int stride, const float* tm, int type = 0, unsigned int v = 0);
    static void warpaffine_bilinear_c2(const unsigned char* src, int srcw, int srch, int srcstride, unsigned char* dst, int w, int h, int stride, const float* tm, int type = 0, unsigned int v = 0);
    static void warpaffine_bilinear_c3(const unsigned char* src, int srcw, int srch, int srcstride, unsigned char* dst, int w, int h, int stride, const float* tm, int type = 0, unsigned int v = 0);
    static void warpaffine_bilinear_c4(const unsigned char* src, int srcw, int srch, int srcstride, unsigned char* dst, int w, int h, int stride, const float* tm, int type = 0, unsigned int v = 0);

    // image pixel bilinear warpaffine, convenient wrapper for yuv420sp(nv21/nv12), set -233 for transparent border color, the color YUV_ is little-endian encoded
    static void warpaffine_bilinear_yuv420sp(const unsigned char* src_y, const unsigned char* src_uv, int srcw, int srch, int src_ystride, int src_uvstride, unsigned char* dst_y, unsigned char* dst_uv, int w, int h, int ystride, int uvstride, const float* tm, int type = 0, unsigned int v = 0x00808000);
};

