#include "../defines.h"
#include "../stencil2d_clstr_hw_defines.h"

#define F_SIZE       3

#define EPSILON 1.0e-6
#define rcIndex     (r*COL + c)

extern volatile int stage;

typedef struct {
    TYPE * inp;
    TYPE * sol;
    TYPE * filter;
    TYPE * check;
} stencil_struct;

int checkData( stencil_struct * sts ) {
    int i;

    for (i = 0; i < ROW*COL; i++) {
        if (sts->sol[i]!= sts->check[i]) {
            printf("Check Failed\n");
            return 0;
        }
    }
    printf("Check Passed\n");

    return 1;
}

void genData(stencil_struct * sts) {
    int r, c, k1, k2, temp, mul, sol;

    for( r=0; r < ROW; r++ ) {
        for( c=0; c < COL; c++ ) {
            sts->inp[rcIndex] = rcIndex;
            //printf("Input[%d]=%d\n", rcIndex, rcIndex);
        }
    }

    for(k1=0; k1 < F_SIZE; k1++) {
        for (k2=0; k2 < F_SIZE; k2++){
            sts->filter[k1*F_SIZE + k2] = k1*F_SIZE + k2;
        }
    }

    for( r=0; r < ROW-2; r++ ) {
        for( c=0; c < COL-2; c++ ) {
            temp = (TYPE)0;

            for(k1=0; k1 < F_SIZE; k1++) {
                for (k2=0; k2 < F_SIZE; k2++){
                    mul = sts->filter[k1*F_SIZE + k2] * sts->inp[(r+k1)*COL + c + k2];
                    temp += mul;
                }
            }
            sts->check[rcIndex] = temp;
        }
    }

}

