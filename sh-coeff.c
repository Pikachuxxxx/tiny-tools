#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

#include <math.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct { float x,y,z; } Vec3;

static inline Vec3 v3(float x, float y, float z) { Vec3 v={x,y,z}; return v; }
static inline Vec3 v3_add(Vec3 a, Vec3 b) { return v3(a.x+b.x, a.y+b.y, a.z+b.z); }
static inline Vec3 v3_scale(Vec3 a, float s) { return v3(a.x*s, a.y*s, a.z*s); }

// SH basis constants (real SH, l<=2)
static inline void sh_basis(float x, float y, float z, float *out9) {
    out9[0] = 0.282095f;
    out9[1] = 0.488603f * y;
    out9[2] = 0.488603f * z;
    out9[3] = 0.488603f * x;
    out9[4] = 1.092548f * x * y;
    out9[5] = 1.092548f * y * z;
    out9[6] = 0.315392f * (3.0f*z*z - 1.0f);
    out9[7] = 1.092548f * x * z;
    out9[8] = 0.546274f * (x*x - y*y);
}

int main(int argc, char **argv)
{
    if (argc < 2) {
        fprintf(stderr,"Usage: %s <hdr latlong image>\n", argv[0]);
        return 1;
    }

    int W,H,N;
    float *img = stbi_loadf(argv[1], &W, &H, &N, 3); // force RGB float
    if (!img) {
        fprintf(stderr,"Failed to load %s\n", argv[1]);
        return 1;
    }

    Vec3 sh[9];
    for (int i=0;i<9;i++) sh[i]=v3(0,0,0);

    const float dtheta = (2.0f*M_PI)/W;
    const float dphi   = (M_PI)/H;

    for (int y=0;y<H;y++) {
        float phi = (y+0.5f) * dphi; // polar angle [0,pi]
        float sinPhi = sinf(phi);
        float cosPhi = cosf(phi);
        for (int x=0;x<W;x++) {
            float theta = (x+0.5f) * dtheta; // azimuth [0,2pi]
            float cosTheta = cosf(theta);
            float sinTheta = sinf(theta);

            // direction vector
            float dx = sinPhi * cosTheta;
            float dy = sinPhi * sinTheta;
            float dz = cosPhi;

            // texel radiance
            int idx = (y*W + x)*3;
            Vec3 L = v3(img[idx+0], img[idx+1], img[idx+2]);

            // solid angle weight
            float dOmega = dtheta * dphi * sinPhi;

            // evaluate SH basis
            float Y[9];
            sh_basis(dx,dy,dz,Y);

            for (int i=0;i<9;i++) {
                sh[i] = v3_add(sh[i], v3_scale(L, Y[i]*dOmega));
            }
        }
    }

    stbi_image_free(img);

    // print coefficients
    for (int i=0;i<9;i++) {
        printf("c[%d] = (%g, %g, %g)\n", i, sh[i].x, sh[i].y, sh[i].z);
    }

    return 0;
}

