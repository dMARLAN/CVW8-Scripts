---
--- Various Enums
--- @author Marlan
---

PRESSURE = {
    STANDARD_PRESSURE_PASCAL = 101325
}

RADIOS = {
    BTN_1 = "305.000",
    BTN_2 = "264.000",
    BTN_3 = "250.100", -- Default is 265.000
    BTN_4 = "256.000",
    BTN_5 = "254.000",
    BTN_6 = "250.000",
    BTN_7 = "270.000",
    BTN_8 = "257.000",
    BTN_9 = "255.000",
    BTN_10 = "262.000",
    BTN_11 = "259.000",
    BTN_12 = "268.000",
    BTN_13 = "269.000",
    BTN_14 = "260.000",
    BTN_15 = "263.000",
    BTN_16 = "261.000",
    BTN_17 = "267.000",
    BTN_18 = "251.000",
    BTN_19 = "253.000",
    BTN_20 = "254.325" -- Default is 266.000
}

AWACS = {
    SPEED = 260
}

TANKERS = {
    SPEED = 280,
    TO11 = {
        TCN_FREQ = 41,
        TCN_ID = "TO1",
        BTN = RADIOS.BTN_13
    },
    TO21 = {
        TCN_FREQ = 42,
        TCN_ID = "TO2",
        BTN = RADIOS.BTN_14
    },
    AO31 = {
        TCN_FREQ = 43,
        TCN_ID = "AO3",
        BTN = RADIOS.BTN_15
    },
    AO41 = {
        TCN_FREQ = 44,
        TCN_ID = "AO4",
        BTN = RADIOS.BTN_17
    },
    SL51 = {
        TCN_FREQ = 45,
        TCN_ID = "SL5",
        BTN = RADIOS.BTN_18
    },
    SL61 = {
        TCN_FREQ = 46,
        TCN_ID = "SL6",
        BTN = RADIOS.BTN_19
    }
}

PHASE = {
    FRS = "frs",
    SFARP = "sfarp",
    TSTA = "tsta",
    AWN = "awn",
    C2X = "c2x",
    DEPLOY = "deploy"
}

THEATRE = {
    CAUCASUS = "Caucasus",
    NEVADA = "Nevada",
    PERSIAN_GULF = "PersianGulf",
    MARIANA_ISLANDS = "MarianaIslands",
    SYRIA = "Syria",
    SOUTH_ATLANTIC = "SouthAtlantic",
}

CONVERSION = {
    PASCALS_TO_INHG = 0.0295299830714,
    METERS_TO_FEET = 3.28084,
    STD_PRESSURE_MILLIBAR = 1013.25,
    METERS_TO_KNOTS = 1.94384,
    FEET_TO_STATUTORY_MILES = 0.000189394,
    PASCAL_TO_MILLIBAR = 0.01,
    ZERO_CELCIUS_IN_KELVIN = 273.15
}

BASES = {
    CARRIER = {
        NAME = "USS Roosevelt",
        CODE = "CVN71"
    },
    AL_DHAFRA_AFB = {
        NAME = "Al Dhafra AFB",
        CODE = "OMAM"
    },
    ANDERSEN_AFB = {
        NAME = "Andersen AFB",
        CODE = "PGUA"
    },
    BATUMI = {
        NAME = "Batumi",
        CODE = "UGSB"
    },
    INCIRLIK = {
        NAME = "Incirlik",
        CODE = "LTAG"
    },
    NELLIS_AFB = {
        NAME = "Nellis",
        CODE = "KLSV"
    },
    MOUNT_PLEASANT_AFB = {
        NAME = "?????",
        CODE = "EGYP"
    },
}
