/**
 * OSAL behavior definition file.
 */

#include "OSAL.hh"
#include "dct.h"

OPERATION(LIFT_PI8_1)
    TRIGGER

    sample_t a = INT(1);
    sample_t b = INT(2);

    sample_t tmp = (b*L1_8) >> S1_8;
    sample_t res = tmp+a;

    IO(3) = res;

    return true;
END_TRIGGER
END_OPERATION(LIFT_PI8_1)

OPERATION(LIFT_PI8_2)
    TRIGGER

    sample_t a = INT(1);
    sample_t b = INT(2);

    sample_t tmp = (a*L2_8) >> S2_8;
    sample_t res = b-tmp;

    IO(3) = res;

    return true;
END_TRIGGER
END_OPERATION(LIFT_PI8_2)

OPERATION(LIFT_PI16_1)
    TRIGGER

    sample_t a = INT(1);
    sample_t b = INT(2);

    sample_t tmp = (b*L1_16) >> S1_16;
    sample_t res = tmp+a;

    IO(3) = res;

    return true;
END_TRIGGER
END_OPERATION(LIFT_PI16_1)

OPERATION(LIFT_PI16_2)
    TRIGGER

    sample_t a = INT(1);
    sample_t b = INT(2);

    sample_t tmp = (a*L2_16) >> S2_16;
    sample_t res = b-tmp;

    IO(3) = res;

    return true;
END_TRIGGER
END_OPERATION(LIFT_PI16_2)

OPERATION(LIFT_PI316_1)
    TRIGGER

    sample_t a = INT(1);
    sample_t b = INT(2);

    sample_t tmp = (b*L1_316) >> S1_316;
    sample_t res = tmp+a;

    IO(3) = res;

    return true;
END_TRIGGER
END_OPERATION(LIFT_PI316_1)

OPERATION(LIFT_PI316_2)
    TRIGGER

    sample_t a = INT(1);
    sample_t b = INT(2);

    sample_t tmp = (a*L2_316) >> S2_316;
    sample_t res = b-tmp;

    IO(3) = res;

    return true;
END_TRIGGER
END_OPERATION(LIFT_PI316_2)
