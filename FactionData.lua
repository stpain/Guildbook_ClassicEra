

local addonName, addon = ...;

--1=friendly > 4=exalted


--itemID, rep, faction
addon.factionData = {

    --[[
    {68996,6,1204,},
    {68998,6,1204,},
    {69000,6,1204,},
    {69001,6,1204,},
    {69002,6,1204,},
    {69184,6,1204,},
    {69185,6,1204,},
    {69198,6,1204,},
    {69199,6,1204,},
    {69200,6,1204,},
    {70930,4,1204,},
    {70933,5,1204,},
    {70934,7,1204,},
    {71131,5,1204,},
    {71215,7,1204,},
    {71216,7,1204,},
    {71217,7,1204,},
    {71227,4,1204,},
    {71228,4,1204,},
    {71229,4,1204,},
    {71230,4,1204,},
    {71237,7,1204,},
    {71249,5,1204,},
    {71250,5,1204,},
    {71253,5,1204,},
    {71254,5,1204,},
    {71255,5,1204,},
    {71258,5,1204,},
    {71388,4,1204,},
    {71389,4,1204,},
    {71390,4,1204,},
    {71391,4,1204,},
    {71392,4,1204,},
    {71393,5,1204,},
    {71394,5,1204,},
    {71395,5,1204,},
    {71396,5,1204,},
    {71397,5,1204,},
    {71398,5,1204,},
    {71399,5,1204,},
    {71400,5,1204,},
    {62454,6,1178,},
    {62455,6,1178,},
    {62456,6,1178,},
    {62457,6,1178,},
    {62458,6,1178,},
    {62459,6,1178,},
    {62460,6,1178,},
    {62463,7,1178,},
    {62464,7,1178,},
    {62465,7,1178,},
    {62466,7,1178,},
    {62467,7,1178,},
    {63376,6,1178,},
    {63378,5,1178,},
    {63518,4,1178,},
    {64993,4,1178,},
    {64994,4,1178,},
    {64995,4,1178,},
    {64996,5,1178,},
    {64997,5,1178,},
    {64999,7,1178,},
    {65176,5,1178,},
    {65356,7,1178,},
    {68740,6,1178,},
    {62479,6,1177,},
    {62468,7,1177,},
    {62469,7,1177,},
    {62470,7,1177,},
    {62471,7,1177,},
    {62472,7,1177,},
    {62473,6,1177,},
    {62474,6,1177,},
    {62475,6,1177,},
    {62476,6,1177,},
    {62477,6,1177,},
    {62478,6,1177,},
    {63039,7,1177,},
    {63141,5,1177,},
    {63144,4,1177,},
    {63145,4,1177,},
    {63355,5,1177,},
    {63377,6,1177,},
    {63379,5,1177,},
    {63391,4,1177,},
    {63517,4,1177,},
    {64998,7,1177,},
    {65175,5,1177,},
    {68739,6,1177,},
    {62422,6,1174,},
    {62423,5,1174,},
    {62424,5,1174,},
    {62425,5,1174,},
    {62426,5,1174,},
    {62427,6,1174,},
    {62428,6,1174,},
    {62429,6,1174,},
    {62430,6,1174,},
    {62431,7,1174,},
    {62432,7,1174,},
    {62433,7,1174,},
    {62434,7,1174,},
    {65908,4,1174,},
    {62369,6,1173,},
    {62436,5,1173,},
    {62437,5,1173,},
    {62438,5,1173,},
    {62439,5,1173,},
    {62440,6,1173,},
    {62441,6,1173,},
    {62445,6,1173,},
    {62446,6,1173,},
    {62447,7,1173,},
    {62448,7,1173,},
    {62449,7,1173,},
    {62450,7,1173,},
    {63044,7,1173,},
    {63045,7,1173,},
    {65904,4,1173,},
    {62368,6,1172,},
    {62404,5,1172,},
    {62405,5,1172,},
    {62406,5,1172,},
    {62407,5,1172,},
    {62408,6,1172,},
    {62409,6,1172,},
    {62410,6,1172,},
    {62415,6,1172,},
    {62416,7,1172,},
    {62417,7,1172,},
    {62418,7,1172,},
    {62420,7,1172,},
    {65909,4,1172,},
    {62321,5,1171,},
    {62333,7,1171,},
    {62342,5,1171,},
    {62343,7,1171,},
    {62344,5,1171,},
    {62345,7,1171,},
    {62346,7,1171,},
    {62347,5,1171,},
    {62348,6,1171,},
    {62350,6,1171,},
    {62351,6,1171,},
    {62352,6,1171,},
    {65907,4,1171,},
    {62288,4,1168,},
    {63359,4,1168,},
    {64398,4,1168,},
    {64399,4,1168,},
    {64400,4,1168,},
    {64401,4,1168,},
    {64402,4,1168,},
    {65460,4,1168,},
    {62367,6,1158,},
    {62374,5,1158,},
    {62375,5,1158,},
    {62376,5,1158,},
    {62377,5,1158,},
    {62378,6,1158,},
    {62380,6,1158,},
    {62381,6,1158,},
    {62382,6,1158,},
    {62383,7,1158,},
    {62384,7,1158,},
    {62385,7,1158,},
    {62386,7,1158,},
    {65906,4,1158,},

    
    {49953,6,1156,},
    {49954,5,1156,},
    {49955,6,1156,},
    {49956,5,1156,},
    {49957,6,1156,},
    {49958,5,1156,},
    {49959,6,1156,},
    {49961,5,1156,},
    {49962,6,1156,},
    {49963,5,1156,},
    {49965,6,1156,},
    {49966,5,1156,},
    {49969,6,1156,},
    {49970,5,1156,},
    {49971,6,1156,},
    {49972,5,1156,},
    {49973,6,1156,},
    {49974,5,1156,},
    {50375,4,1156,},
    {50376,4,1156,},
    {50377,4,1156,},
    {50378,4,1156,},
    {50384,5,1156,},
    {50386,5,1156,},
    {50387,5,1156,},
    {50388,5,1156,},
    {50397,6,1156,},
    {50398,7,1156,},
    {50399,6,1156,},
    {50400,7,1156,},
    {50401,6,1156,},
    {50402,7,1156,},
    {50403,6,1156,},
    {50404,7,1156,},
    {52569,4,1156,},
    {52570,5,1156,},
    {52571,6,1156,},
    {52572,7,1156,},
    

    {62353,5,1135,},
    {62354,5,1135,},
    {62355,5,1135,},
    {62356,5,1135,},
    {62357,6,1135,},
    {62358,6,1135,},
    {62359,6,1135,},
    {62361,6,1135,},
    {62362,7,1135,},
    {62363,7,1135,},
    {62364,7,1135,},
    {62365,7,1135,},
    {62366,6,1135,},
    {65905,4,1135,},

    
    {64892,7,1134,},
    {64893,7,1134,},
    {64894,7,1134,},
    {64905,7,1133,},
    {64906,7,1133,},
    {64907,7,1133,},
    {46814,7,1124,},
    {46816,7,1124,},
    {46818,7,1124,},
    {46821,7,1124,},
    {41720,7,1119,},
    {42184,7,1119,},
    {43958,6,1119,},
    {43961,7,1119,},
    {44080,6,1119,},
    {44086,7,1119,},
    {44125,5,1119,},
    {44126,7,1119,},
    {44129,5,1119,},
    {44130,5,1119,},
    {44131,5,1119,},
    {44132,5,1119,},
    {44137,5,1119,},
    {44189,5,1119,},
    {44190,5,1119,},
    {44191,6,1119,},
    {44192,6,1119,},
    {44193,6,1119,},
    {44194,6,1119,},
    {44195,6,1119,},
    {44510,5,1119,},
    {50335,7,1119,},
    {50336,7,1119,},
    {50337,7,1119,},
    {50338,7,1119,},
    {206392,4,1119,},
    {41726,6,1106,},
    {42187,7,1106,},
    {43154,4,1106,},
    {44139,5,1106,},
    {44214,6,1106,},
    {44216,5,1106,},
    {44239,5,1106,},
    {44240,5,1106,},
    {44244,6,1106,},
    {44245,6,1106,},
    {44247,6,1106,},
    {44248,6,1106,},
    {44283,7,1106,},
    {44295,7,1106,},
    {44296,7,1106,},
    {44297,7,1106,},
    {50369,6,1106,},
    {39878,6,1105,},
    {41567,4,1105,},
    {41724,6,1105,},
    {44104,6,1105,},
    {44065,4,1105,},
    {44071,5,1105,},
    {44074,7,1105,},
    {44106,6,1105,},
    {44108,6,1105,},
    {44109,6,1105,},
    {44110,6,1105,},
    {44111,6,1105,},
    {44112,6,1105,},
    {41561,4,1104,},
    {41723,6,1104,},
    {44064,4,1104,},
    {44072,4,1104,},
    {44073,7,1104,},
    {44116,6,1104,},
    {44117,6,1104,},
    {44118,6,1104,},
    {44120,6,1104,},
    {44121,6,1104,},
    {44122,6,1104,},
    {44123,6,1104,},
    {44717,6,1104,},
    {41562,4,1098,},
    {41721,6,1098,},
    {41725,7,1098,},
    {42183,6,1098,},
    {43155,4,1098,},
    {44138,5,1098,},
    {44241,5,1098,},
    {44242,5,1098,},
    {44243,5,1098,},
    {44249,6,1098,},
    {44250,6,1098,},
    {44256,6,1098,},
    {44257,6,1098,},
    {44258,6,1098,},
    {44302,7,1098,},
    {44303,7,1098,},
    {44305,7,1098,},
    {44306,7,1098,},
    {50367,6,1098,},
    {46817,7,1094,},
    {46813,7,1094,},
    {46815,7,1094,},
    {46820,7,1094,},
    {41722,7,1091,},
    {42185,6,1091,},
    {43156,4,1091,},
    {43955,7,1091,},
    {44140,5,1091,},
    {44187,5,1091,},
    {44188,5,1091,},
    {44196,5,1091,},
    {44197,5,1091,},
    {44198,6,1091,},
    {44199,6,1091,},
    {44200,6,1091,},
    {44201,6,1091,},
    {44202,7,1091,},
    {44203,7,1091,},
    {44204,7,1091,},
    {44205,7,1091,},
    {46326,6,1091,},
    {46327,6,1091,},
    {46328,6,1091,},
    {46329,6,1091,},
    {46330,6,1091,},
    {46331,6,1091,},
    {46332,6,1091,},
    {46333,6,1091,},
    {46334,6,1091,},
    {46335,6,1091,},
    {50370,6,1091,},
    {41718,7,1090,},
    {42188,7,1090,},
    {43157,4,1090,},
    {44141,5,1090,},
    {44166,5,1090,},
    {44167,5,1090,},
    {44170,5,1090,},
    {44171,5,1090,},
    {44173,6,1090,},
    {44174,6,1090,},
    {44176,6,1090,},
    {44179,6,1090,},
    {44180,7,1090,},
    {44181,7,1090,},
    {44182,7,1090,},
    {44183,7,1090,},
    {50368,6,1090,},
    {29193,6,1077,},
    {34665,6,1077,},
    {34666,6,1077,},
    {34667,6,1077,},
    {34670,6,1077,},
    {34671,6,1077,},
    {34672,6,1077,},
    {34673,6,1077,},
    {34674,6,1077,},
    {34675,7,1077,},
    {34676,7,1077,},
    {34677,7,1077,},
    {34678,7,1077,},
    {34679,7,1077,},
    {34680,7,1077,},
    {34780,4,1077,},
    {34872,5,1077,},
    {35221,7,1077,},
    {35238,5,1077,},
    {35239,5,1077,},
    {35240,5,1077,},
    {35241,6,1077,},
    {35242,7,1077,},
    {35243,7,1077,},
    {35244,4,1077,},
    {35245,4,1077,},
    {35246,4,1077,},
    {35247,7,1077,},
    {35248,4,1077,},
    {35249,4,1077,},
    {35250,4,1077,},
    {35251,5,1077,},
    {35252,6,1077,},
    {35253,5,1077,},
    {35254,5,1077,},
    {35255,4,1077,},
    {35256,4,1077,},
    {35257,7,1077,},
    {35258,7,1077,},
    {35259,6,1077,},
    {35260,4,1077,},
    {35261,4,1077,},
    {35262,4,1077,},
    {35263,4,1077,},
    {35264,4,1077,},
    {35265,7,1077,},
    {35266,5,1077,},
    {35267,7,1077,},
    {35268,5,1077,},
    {35269,5,1077,},
    {35270,7,1077,},
    {35271,6,1077,},
    {35322,7,1077,},
    {35323,7,1077,},
    {35325,7,1077,},
    {35500,5,1077,},
    {35502,6,1077,},
    {35505,6,1077,},
    {35695,6,1077,},
    {35696,6,1077,},
    {35697,6,1077,},
    {35698,6,1077,},
    {35699,6,1077,},
    {35708,6,1077,},
    {35752,7,1077,},
    {35753,7,1077,},
    {35754,7,1077,},
    {35755,7,1077,},
    {35766,6,1077,},
    {35767,6,1077,},
    {35768,6,1077,},
    {35769,6,1077,},
    {37504,7,1077,},
    {41568,4,1073,},
    {41574,5,1073,},
    {44049,4,1073,},
    {44050,7,1073,},
    {44051,6,1073,},
    {44052,6,1073,},
    {44053,6,1073,},
    {44054,5,1073,},
    {44055,5,1073,},
    {44057,5,1073,},
    {44058,5,1073,},
    {44059,5,1073,},
    {44060,5,1073,},
    {44061,5,1073,},
    {44062,5,1073,},
    {44509,6,1073,},
    {44511,5,1073,},
    {44723,7,1073,},
    {45774,6,1073,},
    {38452,6,1052,},
    {38454,6,1052,},
    {38456,6,1052,},
    {38458,6,1052,},
    {38460,6,1052,},
    {38461,6,1052,},
    {38462,6,1052,},
    {44502,7,1052,},
    {44938,7,1052,},
    {50373,7,1052,},
    {32645,7,1038,},
    {32647,7,1038,},
    {32648,7,1038,},
    {32650,6,1038,},
    {32651,7,1038,},
    {32652,6,1038,},
    {32653,6,1038,},
    {32654,6,1038,},
    {32783,5,1038,},
    {32784,5,1038,},
    {32828,7,1038,},
    {32909,4,1038,},
    {32910,4,1038,},
    {38453,6,1037,},
    {38455,6,1037,},
    {38457,6,1037,},
    {38459,6,1037,},
    {38463,6,1037,},
    {38464,6,1037,},
    {38465,6,1037,},
    {44503,7,1037,},
    {44937,7,1037,},
    {50372,7,1037,},
    {38628,7,1031,},
    {32314,7,1031,},
    {32316,7,1031,},
    {32317,7,1031,},
    {32318,7,1031,},
    {32319,7,1031,},
    {32445,7,1031,},
    {32538,6,1031,},
    {32539,6,1031,},
    {32721,5,1031,},
    {32722,4,1031,},
    {32770,7,1031,},
    {32771,7,1031,},
    {32621,3,1015,},
    {32694,4,1015,},
    {32695,5,1015,},
    {32726,4,1015,},
    {32864,6,1015,},
    {32429,4,1012,},
    {32430,4,1012,},
    {32431,5,1012,},
    {32432,5,1012,},
    {32433,5,1012,},
    {32434,5,1012,},
    {32435,4,1012,},
    {32436,4,1012,},
    {32437,5,1012,},
    {32438,4,1012,},
    {32439,5,1012,},
    {32440,4,1012,},
    {32441,5,1012,},
    {32442,4,1012,},
    {32443,5,1012,},
    {32444,4,1012,},
    {32447,5,1012,},
    {32485,7,1012,},
    {32486,7,1012,},
    {32487,7,1012,},
    {32488,7,1012,},
    {32489,7,1012,},
    {32490,7,1012,},
    {32491,7,1012,},
    {32492,7,1012,},
    {32493,7,1012,},
    {185691,5,1011,},
    {22538,5,1011,},
    {22910,6,1011,},
    {23138,4,1011,},
    {24175,6,1011,},
    {24179,6,1011,},
    {29199,5,1011,},
    {30830,7,1011,},
    {30832,7,1011,},
    {30833,5,1011,},
    {30834,7,1011,},
    {30835,6,1011,},
    {30836,6,1011,},
    {30841,6,1011,},
    {30845,5,1011,},
    {30846,6,1011,},
    {31357,7,1011,},
    {31778,7,1011,},
    {33148,7,1011,},
    {33157,6,1011,},
    {35331,5,1011,},
    {35335,5,1011,},
    {35340,5,1011,},
    {35344,5,1011,},
    {35357,5,1011,},
    {35361,5,1011,},
    {35370,5,1011,},
    {35373,5,1011,},
    {35378,5,1011,},
    {35382,5,1011,},
    {35389,5,1011,},
    {35391,5,1011,},
    {35405,5,1011,},
    {35411,5,1011,},
    {35412,5,1011,},
    {186683,6,990,},
    {31735,5,990,},
    {31737,5,990,},
    {32274,4,990,},
    {32277,4,990,},
    {32281,4,990,},
    {32282,4,990,},
    {32283,4,990,},
    {32284,4,990,},
    {32286,4,990,},
    {32287,4,990,},
    {32288,4,990,},
    {32290,4,990,},
    {32291,4,990,},
    {32292,6,990,},
    {32293,4,990,},
    {32294,4,990,},
    {32299,5,990,},
    {32300,5,990,},
    {32301,5,990,},
    {32302,6,990,},
    {32304,5,990,},
    {32305,5,990,},
    {32306,5,990,},
    {32308,6,990,},
    {32309,6,990,},
    {32310,5,990,},
    {32311,5,990,},
    {32312,5,990,},
    {35762,5,990,},
    {35763,5,990,},
    {35764,5,990,},
    {35765,5,990,},
    {185693,5,989,},
    {185925,5,989,},
    {22536,5,989,},
    {24174,6,989,},
    {24181,6,989,},
    {25910,5,989,},
    {28272,5,989,},
    {29181,7,989,},
    {29182,7,989,},
    {29183,7,989,},
    {29184,6,989,},
    {29185,6,989,},
    {29186,6,989,},
    {29198,5,989,},
    {29713,5,989,},
    {31355,7,989,},
    {31777,7,989,},
    {33152,7,989,},
    {33158,6,989,},
    {33160,5,989,},
    {35328,5,989,},
    {35334,5,989,},
    {35338,5,989,},
    {35346,5,989,},
    {35356,5,989,},
    {35363,5,989,},
    {35369,5,989,},
    {35372,5,989,},
    {35376,5,989,},
    {35384,5,989,},
    {35390,5,989,},
    {35393,5,989,},
    {35402,5,989,},
    {35410,5,989,},
    {35414,5,989,},
    {187048,5,978,},
    {187049,5,978,},
    {29136,7,978,},
    {29138,7,978,},
    {29140,7,978,},
    {29142,6,978,},
    {29144,5,978,},
    {29146,6,978,},
    {29148,6,978,},
    {29217,4,978,},
    {29218,6,978,},
    {29219,5,978,},
    {29227,7,978,},
    {29229,7,978,},
    {29230,7,978,},
    {29231,7,978,},
    {30443,6,978,},
    {30444,5,978,},
    {31774,7,978,},
    {31830,7,978,},
    {31832,7,978,},
    {31834,7,978,},
    {31836,7,978,},
    {34173,5,978,},
    {34175,5,978,},
    {38229,6,970,},
    {22906,7,970,},
    {22916,6,970,},
    {25548,4,970,},
    {25550,5,970,},
    {25827,5,970,},
    {25828,5,970,},
    {29149,6,970,},
    {29150,6,970,},
    {31775,7,970,},
    {34478,7,970,},
    {29187,5,967,},
    {31393,5,967,},
    {31394,6,967,},
    {31395,5,967,},
    {31401,5,967,},
    {33124,7,967,},
    {33165,7,967,},
    {33205,6,967,},
    {33209,5,967,},
    {34581,6,967,},
    {34582,6,967,},
    {185686,5,947,},
    {24000,4,947,},
    {24001,5,947,},
    {24002,7,947,},
    {24003,6,947,},
    {24004,7,947,},
    {24006,4,947,},
    {24009,4,947,},
    {25738,4,947,},
    {25739,5,947,},
    {25740,5,947,},
    {25823,5,947,},
    {25824,5,947,},
    {29152,7,947,},
    {29155,7,947,},
    {29165,7,947,},
    {29167,6,947,},
    {29168,6,947,},
    {29190,6,947,},
    {29197,5,947,},
    {29232,5,947,},
    {31358,6,947,},
    {31359,4,947,},
    {31361,5,947,},
    {31362,7,947,},
    {32882,6,947,},
    {33151,7,947,},
    {35332,5,947,},
    {35337,5,947,},
    {35339,5,947,},
    {35343,5,947,},
    {35360,5,947,},
    {35364,5,947,},
    {35366,5,947,},
    {35371,5,947,},
    {35377,5,947,},
    {35383,5,947,},
    {35386,5,947,},
    {35392,5,947,},
    {35406,5,947,},
    {35409,5,947,},
    {35413,5,947,},
    {185687,5,946,},
    {22531,4,946,},
    {22547,6,946,},
    {22905,5,946,},
    {23142,4,946,},
    {23619,7,946,},
    {23999,7,946,},
    {24007,4,946,},
    {24008,4,946,},
    {24180,6,946,},
    {25825,5,946,},
    {25826,5,946,},
    {25870,5,946,},
    {29151,7,946,},
    {29153,7,946,},
    {29156,7,946,},
    {29166,6,946,},
    {29169,6,946,},
    {29189,6,946,},
    {29196,5,946,},
    {29213,4,946,},
    {29214,5,946,},
    {29215,5,946,},
    {29719,5,946,},
    {29722,7,946,},
    {32883,6,946,},
    {33150,7,946,},
    {34218,6,946,},
    {35464,5,946,},
    {35465,5,946,},
    {35466,5,946,},
    {35467,5,946,},
    {35468,5,946,},
    {35469,5,946,},
    {35470,5,946,},
    {35471,5,946,},
    {35472,5,946,},
    {35473,5,946,},
    {35474,5,946,},
    {35475,5,946,},
    {35476,5,946,},
    {35477,5,946,},
    {35478,5,946,},
    {185690,5,942,},
    {22918,6,942,},
    {22922,7,942,},
    {23618,5,942,},
    {23814,4,942,},
    {24183,6,942,},
    {24315,4,942,},
    {24412,6,942,},
    {24417,4,942,},
    {24429,4,942,},
    {25526,5,942,},
    {25735,5,942,},
    {25736,5,942,},
    {25737,4,942,},
    {25835,5,942,},
    {25836,5,942,},
    {25838,5,942,},
    {25869,5,942,},
    {28271,6,942,},
    {28632,5,942,},
    {29170,7,942,},
    {29171,7,942,},
    {29172,7,942,},
    {29173,6,942,},
    {29174,6,942,},
    {29188,6,942,},
    {29192,6,942,},
    {29194,5,942,},
    {29720,5,942,},
    {29721,7,942,},
    {31356,7,942,},
    {31390,7,942,},
    {31391,6,942,},
    {31392,6,942,},
    {31402,7,942,},
    {31804,7,942,},
    {31949,6,942,},
    {32070,5,942,},
    {33149,7,942,},
    {33999,7,942,},
    {34481,4,942,},
    {35329,5,942,},
    {35336,5,942,},
    {35342,5,942,},
    {35347,5,942,},
    {35358,5,942,},
    {35365,5,942,},
    {35367,5,942,},
    {35374,5,942,},
    {35379,5,942,},
    {35385,5,942,},
    {35387,5,942,},
    {35394,5,942,},
    {35403,5,942,},
    {35408,5,942,},
    {35415,5,942,},
    {185923,5,941,},
    {185924,5,941,},
    {22917,6,941,},
    {25741,4,941,},
    {25742,5,941,},
    {25743,6,941,},
    {29102,7,941,},
    {29103,7,941,},
    {29104,7,941,},
    {29105,7,941,},
    {29135,7,941,},
    {29137,7,941,},
    {29139,7,941,},
    {29141,6,941,},
    {29143,5,941,},
    {29145,6,941,},
    {29147,6,941,},
    {29664,5,941,},
    {31773,7,941,},
    {31829,7,941,},
    {31831,7,941,},
    {31833,7,941,},
    {31835,7,941,},
    {34172,5,941,},
    {34174,5,941,},
    {185692,5,935,},
    {185926,5,935,},
    {13517,6,935,},
    {22537,6,935,},
    {22915,6,935,},
    {24182,6,935,},
    {25904,4,935,},
    {28273,5,935,},
    {28281,6,935,},
    {29175,7,935,},
    {29176,7,935,},
    {29177,7,935,},
    {29179,6,935,},
    {29180,6,935,},
    {29191,6,935,},
    {29195,5,935,},
    {29717,5,935,},
    {30826,5,935,},
    {31354,7,935,},
    {31781,7,935,},
    {33153,7,935,},
    {33155,5,935,},
    {33159,6,935,},
    {35330,5,935,},
    {35333,5,935,},
    {35341,5,935,},
    {35345,5,935,},
    {35359,5,935,},
    {35362,5,935,},
    {35368,5,935,},
    {35375,5,935,},
    {35380,5,935,},
    {35381,5,935,},
    {35388,5,935,},
    {35395,5,935,},
    {35404,5,935,},
    {35407,5,935,},
    {35416,5,935,},
    {22908,6,934,},
    {23133,4,934,},
    {23143,5,934,},
    {23597,4,934,},
    {23598,5,934,},
    {23599,6,934,},
    {23600,7,934,},
    {24176,6,934,},
    {24292,5,934,},
    {24294,7,934,},
    {25722,6,934,},
    {28903,5,934,},
    {28904,5,934,},
    {28907,5,934,},
    {28908,5,934,},
    {28909,7,934,},
    {28910,7,934,},
    {28911,7,934,},
    {28912,7,934,},
    {29125,7,934,},
    {29126,7,934,},
    {29131,6,934,},
    {29132,6,934,},
    {29133,6,934,},
    {29134,6,934,},
    {29677,7,934,},
    {29682,5,934,},
    {29684,6,934,},
    {29698,7,934,},
    {29700,6,934,},
    {29701,5,934,},
    {31780,7,934,},
    {22535,6,933,},
    {22552,5,933,},
    {23134,5,933,},
    {23136,4,933,},
    {23146,4,933,},
    {23150,5,933,},
    {23155,5,933,},
    {23874,6,933,},
    {24178,6,933,},
    {24314,5,933,},
    {25732,4,933,},
    {25733,5,933,},
    {25734,6,933,},
    {25902,5,933,},
    {25903,6,933,},
    {25908,5,933,},
    {28274,4,933,},
    {29115,6,933,},
    {29116,6,933,},
    {29117,6,933,},
    {29118,5,933,},
    {29119,7,933,},
    {29121,7,933,},
    {29122,7,933,},
    {29456,5,933,},
    {29457,5,933,},
    {29889,5,933,},
    {31776,7,933,},
    {32412,7,933,},
    {33156,6,933,},
    {33305,6,933,},
    {33622,7,933,},
    {23145,5,932,},
    {23149,4,932,},
    {23601,4,932,},
    {23602,7,932,},
    {23603,5,932,},
    {23604,6,932,},
    {24177,6,932,},
    {24293,5,932,},
    {24295,7,932,},
    {25721,6,932,},
    {28878,5,932,},
    {28881,5,932,},
    {28882,5,932,},
    {28885,5,932,},
    {28886,7,932,},
    {28887,7,932,},
    {28888,7,932,},
    {28889,7,932,},
    {29123,7,932,},
    {29124,7,932,},
    {29127,6,932,},
    {29128,6,932,},
    {29129,5,932,},
    {29130,6,932,},
    {29689,7,932,},
    {29691,6,932,},
    {29693,5,932,},
    {29702,7,932,},
    {29703,6,932,},
    {29704,5,932,},
    {30842,4,932,},
    {30843,5,932,},
    {30844,7,932,},
    {31779,7,932,},
    {46756,7,930,},
    {64889,7,930,},
    {64890,7,930,},
    {64891,7,930,},
    {54703,4,922,},
    {22985,6,922,},
    {22986,6,922,},
    {22987,6,922,},
    {22990,7,922,},
    {22991,4,922,},
    {22992,4,922,},
    {22993,4,922,},
    {23388,7,922,},
    {28155,5,922,},
    {28158,5,922,},
    {28162,5,922,},
    {28164,4,922,},
    {46761,7,911,},
    {64914,7,911,},
    {64915,7,911,},
    {64916,7,911,},

    --911 silvermoon
]]


--910 brood of noz
    {21196,3,910,},
    {21197,4,910,},
    {21198,5,910,},
    {21199,6,910,},
    {21200,7,910,},
    {21201,3,910,},
    {21202,4,910,},
    {21203,5,910,},
    {21204,6,910,},
    {21205,7,910,},
    {21206,3,910,},
    {21207,4,910,},
    {21208,5,910,},
    {21209,6,910,},
    {21210,7,910,},
    {22687,6,749,},
    {22695,6,749,},
    {22698,6,749,},
    {22705,6,749,},
    {20382,7,609,},
    {20506,4,609,},
    {20507,5,609,},
    {20508,6,609,},
    {20509,4,609,},
    {20510,5,609,},
    {20511,6,609,},
    {20732,4,609,},
    {20733,5,609,},
    {22209,4,609,},
    {22214,5,609,},
    {22219,6,609,},
    {22221,7,609,},
    {22310,4,609,},
    {22312,6,609,},
    {22683,6,609,},
    {22766,6,609,},
    {22767,5,609,},
    {22768,4,609,},
    {22769,4,609,},
    {22770,5,609,},
    {22771,6,609,},
    {22772,4,609,},
    {22773,5,609,},
    {22774,6,609,},
    {66888,7,576,},
    {13484,4,576,},
    {19202,5,576,},
    {19204,6,576,},
    {19215,5,576,},
    {19218,6,576,},
    {19326,5,576,},
    {19327,6,576,},
    {19445,5,576,},
    {20253,4,576,},
    {20254,4,576,},
    {21326,7,576,},
    {22392,4,576,},
    {46760,7,530,},
    {64911,7,530,},
    {64912,7,530,},
    {64913,7,530,},
    {1164,5,529,},
    {4996,5,529,},
    {13482,5,529,},
    {13724,4,529,},
    {13810,6,529,},
    {13813,6,529,},
    {19203,5,529,},
    {19205,6,529,},
    {19216,5,529,},
    {19217,6,529,},
    {19328,5,529,},
    {19329,6,529,},
    {19442,5,529,},
    {19446,5,529,},
    {19447,6,529,},
    {22014,5,529,},
    {22684,6,529,},
    {22685,6,529,},
    {22686,6,529,},
    {22692,7,529,},
    {22694,6,529,},
    {22696,7,529,},
    {22697,6,529,},
    {22703,7,529,},
    {22704,6,529,},
    {19764,6,270,},
    {19765,5,270,},
    {19766,4,270,},
    {19769,6,270,},
    {19770,5,270,},
    {19771,4,270,},
    {19772,6,270,},
    {19773,5,270,},
    {19776,6,270,},
    {19777,5,270,},
    {19778,4,270,},
    {19779,6,270,},
    {19780,5,270,},
    {19781,4,270,},
    {20000,5,270,},
    {20001,4,270,},
    {20011,6,270,},
    {20012,4,270,},
    {20014,5,270,},
    {20756,5,270,},
    {20757,4,270,},
    {46755,7,81,},
    {64917,7,81,},
    {64918,7,81,},
    {64919,7,81,},
    {46757,7,76,},
    {64908,7,76,},
    {64909,7,76,},
    {64910,7,76,},
    {46758,7,72,},
    {64901,7,72,},
    {64902,7,72,},
    {64903,7,72,},
    {46759,7,69,},
    {64886,7,69,},
    {64887,7,69,},
    {64888,7,69,},
    {46764,7,68,},
    {64920,7,68,},
    {64921,7,68,},
    {64922,7,68,},
    {20310,3,67,},
    {20761,4,59,},
    {46763,7,54,},
    {64895,7,54,},
    {64896,7,54,},
    {64897,7,54,},
    {46762,7,47,},
    {64898,7,47,},
    {64899,7,47,},
    {64900,7,47,},
    
}

-- addon.factionData.cata = {
--     [1204] = {
--         [1] = {
--             70930,
--             71229,
--             71227,
--             71230,
--             71228,
--         },
--         [2] = {
--             70933,
--             71255,
--             71254,
--             71131,
--             71258,
--             71250,
--             71253,
--             71249
--         },
--         [3] = {

--         },
--         [4] = {

--         },
--     },
-- }